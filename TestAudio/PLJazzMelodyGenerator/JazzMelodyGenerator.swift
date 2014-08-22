//
//  JazzMelodyGenerator.swift
//  TestAudio
//
//  Created by Peter Livesey on 6/19/14.
//  Copyright (c) 2014 Peter Livesey. All rights reserved.
//

import Foundation

let MIN_NUMBER_OF_RESTS = 1
let MAX_NUMBER_OF_RESTS = 2

let MIN_NUMBER_OF_MELODY = 2
let MAX_NUMBER_OF_MELODY = 6

let MELODY_MIN: Int = 70
let MELODY_MAX: Int = 90
let MELODY_VARIANCE = 12

func generateMelodyMeasures(#chordMeasures: [ChordMeasure]) -> [MelodyMeasure] {
  var melody = [MelodyMeasure]()
  var currentIndex = 0
  while (melody.count < chordMeasures.count) {
    let melodyMeasuresLeft = chordMeasures.count - melody.count
    // Start with melody
    let melodyNumber = RandomHelpers.randomNumberInclusive(min(MIN_NUMBER_OF_MELODY, melodyMeasuresLeft), min(MAX_NUMBER_OF_MELODY, melodyMeasuresLeft))
    
    if (currentIndex >= chordMeasures.count) {
      break;
    }
    let highIndex = min(melodyNumber + currentIndex, chordMeasures.count)
    let chords = Array(chordMeasures[currentIndex..<highIndex])
    
    let newMelody = melodicPhrase2(chords:chords)
    melody.extend(newMelody)
    
    currentIndex += newMelody.count
    
    // Rests
    if (melody.count < chordMeasures.count) {
      let melodyMeasuresLeft = chordMeasures.count - melody.count
      let maxNumberOfRests = RandomHelpers.randomNumberInclusive(MIN_NUMBER_OF_RESTS, MAX_NUMBER_OF_RESTS)
      let numberOfRests = min(melodyMeasuresLeft, maxNumberOfRests)
      for _ in 0..<numberOfRests {
        melody.append(MelodyMeasure(notes: []))
        currentIndex++
      }
    }
  }
  return melody
}


//func generateMelodyMeasures(#chordMeasures: ChordMeasure[]) -> MelodyMeasure[] {
//  var melody = MelodyMeasure[]()
//  var currentIndex = 0
//  while (melody.count < chordMeasures.count) {
//    let melodyMeasuresLeft = chordMeasures.count - melody.count
//    // Start with melody
//    let melodyNumber = RandomHelpers.randomNumberInclusive(min(MIN_NUMBER_OF_MELODY, melodyMeasuresLeft), min(MAX_NUMBER_OF_MELODY, melodyMeasuresLeft))
//    let melodyOutlineArray = melodyOutline(numberOfMeasures: melodyNumber)
//    
//    let chords = Array(chordMeasures[currentIndex..<chordMeasures.count])
//    
//    let newMelody = melodicPhrase(melodyOutline: melodyOutlineArray, chords:chords)
//    melody.extend(newMelody)
//    
//    currentIndex += melodyNumber / 2
//    
//    // Rests
//    if (melody.count < chordMeasures.count) {
//      let melodyMeasuresLeft = chordMeasures.count - melody.count
//      let maxNumberOfRests = RandomHelpers.randomNumberInclusive(MIN_NUMBER_OF_RESTS, MAX_NUMBER_OF_RESTS)
//      let numberOfRests = min(melodyMeasuresLeft, maxNumberOfRests)
//      for _ in 0..<numberOfRests {
//        melody.append(MelodyMeasure(notes: []))
//        currentIndex++
//      }
//    }
//  }
//  return melody
//}

func melodyOutline(#numberOfMeasures: Int) -> [Int] {
  var melodyOutline = [Int]()
  var currentValue = Int(RandomHelpers.randomNumberInclusive(Int(MELODY_MIN), Int(MELODY_MAX)))
  for _ in 0..<numberOfMeasures {
    melodyOutline.append(currentValue)
    let difference = RandomHelpers.randomNumberInclusive(0, MELODY_VARIANCE*2) - MELODY_VARIANCE
    currentValue += Int(difference)
    currentValue = max(currentValue, MELODY_MIN)
    currentValue = min(currentValue, MELODY_MAX)
  }
  return melodyOutline
}

func melodicPhrase2(#chords: [ChordMeasure]) -> [MelodyMeasure] {
  var melody = [MelodyMeasure]()
  
  let rhythms = rhythmMotifs()
  var currentNote = Int(RandomHelpers.randomNumberInclusive(Int(MELODY_MIN), Int(MELODY_MAX)))
  for chordMeasure in chords {
    var notes = [MelodyNote]()
    let chord = chordMeasure.chords[0].chord
    
    let firstNotes = generateNext2Beats(chord: chord, startNote: currentNote, rhythms: rhythms)
    notes.extend(firstNotes.notes)
    currentNote = firstNotes.nextNote
    
    let nextChord = chordBeat3(chordMeasure)
    let nextNotes = generateNext2Beats(chord: nextChord, startNote: currentNote, rhythms: rhythms)
    notes.extend(nextNotes.notes)
    currentNote = nextNotes.nextNote
    
    melody.append(MelodyMeasure(notes: notes))
  }
  return melody
}

func generateNext2Beats(#chord: ChordData, #startNote: Int, #rhythms: [[Float]]) -> (notes: [MelodyNote], nextNote: Int) {
  var notes = [MelodyNote]()
  let scale = chord.mainChordScale
  var currentNote = startNote
  
  let closestNote = closestNoteIndex(chord.mainChordScale, indexesToCheck: chord.importantScaleIndexes, toNote: currentNote)
  currentNote = chord.mainChordScale[closestNote.index] + closestNote.transposition
  
  let generalDirection = RandomHelpers.randomNumberInclusive(1, 3)
  let motif = rhythms.randomElement()
  let arpeg = RandomHelpers.randomNumberInclusive(0, 2) == 0
  for beat in motif {
    if (RandomHelpers.randomNumberInclusive(0, 9) == 0) {
      // Add a rest
      notes.append((-1, beat))
    } else {
      notes.append((currentNote, beat))
      // calculate next note
      let direction = RandomHelpers.randomNumberInclusive(0, 3)
      if (direction >= generalDirection) {
        // Go up
        currentNote = noteAbove(currentNote, scale: scale)
        if (arpeg) {
          currentNote = noteAbove(currentNote, scale: scale)
        }
      } else {
        // Go down
        currentNote = noteBelow(currentNote, scale: scale)
        if (arpeg) {
          currentNote = noteBelow(currentNote, scale: scale)
        }
      }
    }
  }
  
  return (notes, currentNote)
}

func noteAbove(note: Int, #scale: [Int]) -> Int {
  var zeroedNote = note % 12
  
  // Sort of a hack, revisit later
  if zeroedNote < scale[0] {
    zeroedNote += 12
  }
  
  // Default. use this if noone is higher
  var index = 0
  for i in 0..<scale.count {
    if (scale[i] > zeroedNote) {
      index = i
      // TODO: This line sometimes crashes. Maybe this was just the infinite loop?
      break;
    }
  }
  
  var returnNote = scale[index]
  while (returnNote < note) {
    returnNote += 12
  }
  return returnNote
}

func noteBelow(note: Int, #scale: [Int]) -> Int {
  var zeroedNote = note % 12
  
  // Sort of a hack, revisit later
  if zeroedNote < scale[0] {
    zeroedNote += 12
  }
  // Default. use this if noone is higher
  var index = scale.count-1
  for i in reverse(0..<scale.count-1) {
    if (scale[i] < zeroedNote) {
      index = i
      break;
    }
  }
  
  var returnNote = scale[index]
  while (returnNote < note-12) {
    returnNote += 12
  }
  return returnNote
}

func rhythmMotifs() -> [[Float]] {
  var result = [[Float]]()
  result.append([0.6, 1, 0.4])
  result.append([0.33, 0.33, 0.34, 0.6, 0.4])
  result.append([1, 0.6, 0.4])
  result.append([2])
  result.append([1.6, 0.4])
  result.append([0.6, 0.4, 0.6, 0.4])
  result.append([0.25, 0.25, 0.25, 0.25, 0.6, 0.4])
  result.append([0.25, 0.25, 0.5, 0.25, 0.25, 0.5])
  return result
}

func melodicPhrase(#melodyOutline: [Int], #chords: [ChordMeasure]) -> [MelodyMeasure] {
  var melody = [MelodyMeasure]()
  for i in 0..<melodyOutline.count/2 {
    var notes = [MelodyNote]()
    let chordMeasure = chords[i]
    let currentChord = chordMeasure.chords[0].chord
    let goalChord = chordBeat3(chordMeasure)
    
    let nextNotes = nextTwoBeats(chord: currentChord, nextChord: goalChord, melodyOutlineNotes: melodyOutline[i*2...i*2+1])
    notes.extend(nextNotes)
    
    if (chords.count > i+2 && i*2 + 2 < melodyOutline.count) {
      let currentChord = goalChord
      let goalChord = chords[i+1].chords[0].chord
      
      let nextNotes = nextTwoBeats(chord: currentChord, nextChord: goalChord, melodyOutlineNotes: melodyOutline[i*2+1...i*2+2])
      notes.extend(nextNotes)
    }
    
    melody.append(MelodyMeasure(notes: notes))
  }
  return melody
}

func nextTwoBeats(#chord: ChordData, #nextChord: ChordData, #melodyOutlineNotes: Slice<Int>) -> [MelodyNote] {
  var notes = [MelodyNote]()
  
  let startTuple = importantNote(chord: chord, melodyOutlineNote: melodyOutlineNotes[melodyOutlineNotes.startIndex])
  notes.append((note: startTuple.note, beats: 1))
  
  println("\(chord): \(chord.mainChordScale) chosen: \(startTuple.note)")
  
  let goalTuple = importantNote(chord: nextChord, melodyOutlineNote: melodyOutlineNotes[melodyOutlineNotes.startIndex+1])
  let fromAbove = scaleFromAbove(nextChord.mainChordScale, index: goalTuple.index) + goalTuple.tranposition
  let fromBelow = scaleFromBelow(nextChord.mainChordScale, index: goalTuple.index) + goalTuple.tranposition
  let approachNote = approachNotes(goalTuple.note, scaleAbove: fromAbove, scaleBelow: fromBelow)[0]
  notes.append((note: approachNote.note, beats: 1))
  
  return notes
}

func scaleFromAbove(scale: [Int], #index: Int) -> Int {
  if (index + 1 < scale.count) {
    return scale[index + 1]
  } else {
    return scale[0]+12
  }
}

func scaleFromBelow(scale: [Int], #index: Int) -> Int {
  if (index - 1 > 0) {
    return scale[index - 1]
  } else {
    return scale[scale.count-1]-12
  }
}

func importantNote(#chord: ChordData, #melodyOutlineNote: Int) -> (note: Int, index: Int, tranposition: Int) {
  let result = closestNoteIndex(chord.mainChordScale, indexesToCheck: chord.importantScaleIndexes, toNote: melodyOutlineNote)
  return (chord.mainChordScale[result.index] + result.transposition, result.index, result.transposition)
}

func chordBeat3(chordMeasure: ChordMeasure) -> ChordData {
  var currentBeats: Float = 0
  for chord in chordMeasure.chords {
    currentBeats += chord.beats
    if (currentBeats > 2) {
      return chord.chord
    }
  }
  return chordMeasure.chords[0].chord
}

func approachNotes(note: Int, #scaleAbove: Int, #scaleBelow: Int) -> [MelodyNote] {
  let random = RandomHelpers.randomNumberInclusive(0, 2)
  switch(random) {
  case 0:
    // chrom from below
    return [(note - 1, 1)]
  case 1:
    // chrom from above
    return [(note + 1, 1)]
  case 2:
    // scale from below
    return [(scaleBelow, 1)]
  default:
    // scale from above
    return [(scaleAbove, 1)]
  }
}

func closestNoteIndex(notes:[Int], #indexesToCheck: [Int], #toNote: Int) -> (index: Int, transposition:Int) {
  let zeroBasedNotes: [Int] = notes.map {
    x in return x % 12
  }
  let zeroBasedTarget = toNote % 12
  
  var distance = Int.max
  var i = -1
  for index in indexesToCheck {
    var newDistance = iabs(zeroBasedTarget - zeroBasedNotes[index])
    // TODO: Sometimes crashes
    if (newDistance > 6) {
      newDistance = 12 - newDistance
    }
    if (newDistance < distance) {
      distance = newDistance
      i = index
    }
  }
  
  let answer = notes[i]
  let transposition = (toNote + 6 - answer) / 12
  
  return (i, transposition * 12)
}

func iabs(x: Int) -> Int {
  return x < 0 ? -x : x
}

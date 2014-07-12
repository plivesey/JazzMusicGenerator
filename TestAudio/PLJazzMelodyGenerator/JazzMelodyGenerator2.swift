//
//  JazzMelodyGenerator2.swift
//  TestAudio
//
//  Created by Peter Livesey on 6/26/14.
//  Copyright (c) 2014 Peter Livesey. All rights reserved.
//

import Foundation

class JazzMelodyGenerator {
  
  let MELODY_HIGH = 112
  let MELODY_LOW = 64
  
  class func generateMelodyMeasures(#chordMeasures: [ChordMeasure], solo: Bool) -> [MelodyMeasure] {
    let outline = generateMelodyOutline(chordMeasures: chordMeasures)
    return generateMelody(chordMeasures: chordMeasures, melodyOutline: outline, solo: solo)
  }
  
  // Private
  
  class func generateMelodyOutline(#chordMeasures: [ChordMeasure]) -> [MelodyMeasure] {
    var currentNote: Int8 = 76
    var measures = [MelodyMeasure]()
    
    var beats: Float = 0
    
    for (measureIndex, chordMeasure) in enumerate(chordMeasures) {
      var notes = [MelodyNote]()
      for (chordIndex, chord) in enumerate(chordMeasure.chords) {
        let destinationChordOp = MusicUtil.findNextChordInMeaures(chordMeasures, measureIndex: measureIndex, chordIndex: chordIndex)
        var iterations = 1
        if chord.beats == 4 {
          iterations = 2
        }
        if let destinationChord = destinationChordOp {
          for _ in 0..<iterations {
            let next = nextNotes(currentNote: currentNote, chord: chord.chord, destinationChord: destinationChord)
            currentNote = next.newCurrent
            notes.extend(next.melody)
          }
        } else {
          for _ in 0..<iterations {
            notes.append((currentNote, 2))
          }
        }
      }
      measures.append(MelodyMeasure(notes: notes))
    }
    
    return measures
  }
  
  class func nextNotes(#currentNote: Int8, chord: ChordData, destinationChord: ChordData) -> (melody: [MelodyNote], newCurrent: Int8) {
    let index = RandomHelpers.randomNumberInclusive(0, destinationChord.importantScaleIndexes.count-1)
    let zeroBasedNote = destinationChord.mainChordScale[destinationChord.importantScaleIndexes[index]]
    let lowHigh = surroundingNotes(currentNote, zeroBasedDestination: zeroBasedNote)
    let destination = selectDestination(lowHigh, currentNote:currentNote)
    let nextNotes = nextChordNotes(currentNote: currentNote, destinationNote: destination, chordScale: chord.mainChordScale, number: 1, beatsPerNote: 2)
    return (nextNotes, destination)
  }
  
  class func nextChordNotes(var #currentNote: Int8, destinationNote: Int8, chordScale: [Int8], number: Int, beatsPerNote: Float) -> [MelodyNote] {
    let notes = MusicUtil.notesToDestination(destinationNote, fromStart: currentNote, numberOfNotes: number, chordScale: chordScale)
    return notes.map {
      note in
      return (note, beatsPerNote)
    }
  }
  
  class func generateMelody(#chordMeasures: [ChordMeasure], melodyOutline: [MelodyMeasure], solo: Bool) -> [MelodyMeasure] {
    var measures = [MelodyMeasure]()
    
    var rhythmState = MelodyRhythmGenerator.Speed.Slow
    if solo {
      rhythmState = MelodyRhythmGenerator.Speed.Medium
    }
    var rhythms: [[Float]] = []
    
    var count = 6
    if solo {
      // Totally random
      count = melodyOutline.count * 2
    }
    
    for _ in 0..<count {
      let rhythmTuple = MelodyRhythmGenerator.rhythmForState(rhythmState, solo: solo)
      rhythms.append(rhythmTuple.rhythm)
      rhythmState = rhythmTuple.nextState
    }
    
    var measuresLeftBeforeEnd = 3
    var rhythmIndex = 0
    
    for i in 0..<melodyOutline.count {
      let melodyMeasure = melodyOutline[i]
      let chordMeasure = chordMeasures[i]
      
      var notes = [MelodyNote]()
      
      if measuresLeftBeforeEnd == 0 && !solo {
        notes.append((melodyMeasure.notes[0].note, 2))
        notes.append((-1, 2))
        measuresLeftBeforeEnd = 3
        rhythmIndex = 0
      } else {
        measuresLeftBeforeEnd--
        
        var currentBeat: Float = 0
        
        assert(melodyMeasure.notes.count <= 2)
        
        for noteIndex in 0..<melodyMeasure.notes.count {
          let beats: Float = 2
          let currentNote = melodyMeasure.notes[noteIndex].note
          var destinationNote = MusicUtil.findNextNoteInMelody(melodyOutline, measureIndex: i, noteIndex: noteIndex)
          // TODO: This is a hack. If there's nothing at the end, should go towards start
          if destinationNote == -1 {
            destinationNote = 76
          }
          
          var chord = chordMeasure.chords[0].chord
          if (currentBeat >= 2) {
            chord = chordBeat3(chordMeasure)
          }
          
          // 50% main scale, 50% random scale (maybe main scale)
          var scale = chord.mainChordScale
          // TODO: Previously always did this if a solo. Put it back in?
          if RandomHelpers.randomNumberInclusive(0, 1) == 1 {
            scale = chord.chordScale.randomElement()
          }
          
          let rhythm = rhythms[rhythmIndex++]
          
          let melody = melodyNotes(startNote: currentNote, destinationNote: destinationNote, beats: beats, scale: scale, rhythm: rhythm)
          notes.extend(melody)
          
          currentBeat += beats
        }
      }
      
      measures.append(MelodyMeasure(notes: notes))
    }
    return measures
  }
  
  class func stepNote(var currentNote: Int8, destinationNote: Int8, chordScale: [Int8]) -> Int8 {
    let upwardDirection = currentNote < destinationNote
    do {
      if (upwardDirection) {
        currentNote = noteAbove(currentNote, scale: chordScale)
      } else {
        currentNote = noteBelow(currentNote, scale: chordScale)
      }
    } while (currentNote == destinationNote)
    return currentNote
  }
  
  class func melodyNotes(#startNote: Int8, destinationNote: Int8, beats: Float, scale: [Int8], var rhythm: [Float]) -> [MelodyNote] {
    
    var currentNote = startNote
    var notes = [MelodyNote]()
    
    // Don't hit the down beat. Instead, play an approach pattern
    if rhythm.count >= 2 && rhythm[0] <= 1 && RandomHelpers.randomNumberInclusive(0, 2) == 0 {
      let aNotes = approachNotes(currentNote, scaleAbove: stepNote(currentNote, destinationNote: currentNote+8, chordScale: scale), scaleBelow: stepNote(currentNote, destinationNote: currentNote-8, chordScale: scale))
      let approachNote = aNotes.randomElement().note
      notes.append((approachNote, rhythm[0]))
      
      rhythm = Array(rhythm[1..<rhythm.count])
    }
    
    let notesToPlay = MusicUtil.notesToDestination(destinationNote, fromStart: currentNote, numberOfNotes: rhythm.count, chordScale: scale)
    
    for (index, duration) in enumerate(rhythm) {
      notes.append((notesToPlay[index], duration))
    }
    
    return notes
  }
  
  class func generateRhythm(#beats: Float) -> [Float] {
    if beats == 1 {
      let array: [[Float]] = [
        [ 1.0 ],
        [ 1.0 ],
        [ 0.66, 0.34 ],
        [ 0.33, 0.33, 0.34 ]
      ]
      return array.randomElement()
    } else if beats == 2 {
      let array: [[Float]] = [
        [ 2.0 ],
        [ 2.0 ],
        [ 1, 1 ],
        [ 1.6, 0.4 ],
        [ 0.4, 1.1, 0.5 ],
        [ 1, 0.66, 0.34 ],
        [ 0.66, 0.34, 1 ],
        [ 0.67, 0.67, 0.66 ],
        [ 0.66, 0.34, 0.66, 0.34 ]
      ]
      return array.randomElement()
    } else if beats == 4 {
      let array: [[Float]] = [
        [ 4 ],
        [ 3, 1 ],
        [ 1, 3 ],
        [ 2, 2 ],
        [ 1, 1, 2 ],
        [ 1.33, 1.33, 1.34 ],
        [ 0.5, 1, 1, 1, 0.5 ],
        [ 0.5, 2, 1, 0.5 ],
        [ 0.5, 1, 1, 0.5, 1 ]
      ]
      return array.randomElement()
    }
    return []
  }
  
  // TODO: This function crashes when currentNote goes out of range
  class func surroundingNotes(currentNote: Int8, var zeroBasedDestination: Int8) -> (low: Int8, high: Int8) {
    while (zeroBasedDestination <= currentNote) {
      zeroBasedDestination += 12
    }
    if (zeroBasedDestination == currentNote) {
      return (zeroBasedDestination, zeroBasedDestination)
    } else {
      return (zeroBasedDestination - 12, zeroBasedDestination)
    }
  }
  
  class func selectDestination(lowHigh: (low: Int8, high: Int8), currentNote: Int8) -> Int8 {
    // Check to see if its too low or high
    if (lowHigh.low < MELODY_MIN) {
      return lowHigh.high
    } else if (lowHigh.high > MELODY_MAX) {
      return lowHigh.low
    }
    
    var pivot = 0
    if (currentNote - lowHigh.low == lowHigh.high - currentNote) {
      // 50 - 50
      pivot = 1
    } else if (currentNote - lowHigh.low > lowHigh.high - currentNote) {
      // 25 - 75
      pivot = 0
    } else {
      pivot = 2
    }
    let randomOption = RandomHelpers.randomNumberInclusive(0, 3)
    
    if (randomOption <= pivot) {
      return lowHigh.low
    } else {
      return lowHigh.high
    }
  }
}

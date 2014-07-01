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
  
  class func generateMelodyMeasures(#chordMeasures: ChordMeasure[]) -> MelodyMeasure[] {
    let outline = generateMelodyOutline(chordMeasures: chordMeasures)
    return generateMelody(chordMeasures: chordMeasures, melodyOutline: outline)
  }
  
  // Private
  
  class func generateMelodyOutline(#chordMeasures: ChordMeasure[]) -> MelodyMeasure[] {
    var chords = Array<(chord: ChordData, beats: Float)>()
    for chordMeasure in chordMeasures {
      for chord in chordMeasure.chords {
        chords.append(chord)
      }
    }
    
    var currentNote: Int8 = 76
    var measures = MelodyMeasure[]()
    
    var notes = MelodyNote[]()
    var beats: Float = 0
    
    for i in 0..chords.count {
      let currentChord = chords[i]
      if (i+1 < chords.count) {
        let destinationChord = chords[i+1]
        let next = nextNotes(currentNote: currentNote, beats: currentChord.beats, chord: currentChord.chord, destinationChord: destinationChord.chord)
        currentNote = next.newCurrent
        notes.extend(next.melody)
        beats += currentChord.beats
        if (beats >= 4) {
          beats = 0
          measures.append(MelodyMeasure(notes: notes))
          notes = MelodyNote[]()
        }
      }
    }
    let lastNote = MelodyNote((currentNote, 4))
    measures.append(MelodyMeasure(notes: [lastNote]))
    
    return measures
  }
  
  class func nextNotes(#currentNote: Int8, beats: Float, chord: ChordData, destinationChord: ChordData) -> (melody: MelodyNote[], newCurrent: Int8) {
    let index = randomNumberInclusive(0, destinationChord.importantScaleIndexes.count-1)
    let zeroBasedNote = destinationChord.mainChordScale[destinationChord.importantScaleIndexes[index]]
    let lowHigh = surroundingNotes(currentNote, zeroBasedDestination: zeroBasedNote)
    let destination = selectDestination(lowHigh, currentNote:currentNote)
    println("Chord: \(destinationChord) destinationNote: \(MusicUtil.noteToString(destination%12)) chosen from scale: \(destinationChord.mainChordScale)")
    
    if (beats == 2) {
      let option = randomNumberInclusive(0, 1)
      if (option == 0) {
        let nextNotes = nextChordNotes(currentNote: currentNote, destinationNote: destination, chordScale: chord.mainChordScale, number: 2, beatsPerNote: 1.0)
        return (nextNotes, destination)
      } else {
        let nextNotes = nextChordNotes(currentNote: currentNote, destinationNote: destination, chordScale: chord.mainChordScale, number: 1, beatsPerNote: 2)
        return (nextNotes, destination)
      }
    } else {
      let option = randomNumberInclusive(0, 2)
      if (option == 0) {
        let nextNotes = nextChordNotes(currentNote: currentNote, destinationNote: destination, chordScale: chord.mainChordScale, number: 4, beatsPerNote: 1.0)
        return (nextNotes, destination)
      } else if (option == 1) {
        let nextNotes = nextChordNotes(currentNote: currentNote, destinationNote: destination, chordScale: chord.mainChordScale, number: 2, beatsPerNote: 2.0)
        return (nextNotes, destination)
      } else {
        let nextNotes = nextChordNotes(currentNote: currentNote, destinationNote: destination, chordScale: chord.mainChordScale, number: 1, beatsPerNote: 4.0)
        return (nextNotes, destination)
      }
    }
  }
  
  class func nextChordNotes(var #currentNote: Int8, destinationNote: Int8, chordScale: Int8[], number: Int, beatsPerNote: Float) -> MelodyNote[] {
    var notes = MelodyNote[]()
    for _ in 0..number {
      notes.append((note: currentNote, beats: beatsPerNote))
      currentNote = stepNote(currentNote, destinationNote: destinationNote, chordScale: chordScale)
    }
    return notes
  }
  
  class func generateMelody(#chordMeasures: ChordMeasure[], melodyOutline: MelodyMeasure[]) -> MelodyMeasure[] {
    var measures = MelodyMeasure[]()
    for i in 0..melodyOutline.count {
      let melodyMeasure = melodyOutline[i]
      let chordMeasure = chordMeasures[i]
      
      var notes = MelodyNote[]()
      
      var currentBeat: Float = 0
      for noteIndex in 0..melodyMeasure.notes.count {
        let beats = melodyMeasure.notes[noteIndex].beats
        let currentNote = melodyMeasure.notes[noteIndex].note
        let destinationNote = MusicUtil.findNextNoteInMelody(melodyOutline, measureIndex: i, noteIndex: noteIndex)
        
        var chord = chordMeasure.chords[0].chord
        if (currentBeat >= 2) {
          chord = chordBeat3(chordMeasure)
        }
        let scale = chord.mainChordScale
        
        if destinationNote == -1 {
          // No more notes
          notes.extend([(currentNote, 4)])
        } else {
          let melody = melodyNotes(startNote: currentNote, destinationNote: destinationNote, beats: beats, scale: scale)
          notes.extend(melody)
        }
        
        currentBeat += beats
      }
      
      measures.append(MelodyMeasure(notes: notes))
    }
    return measures
  }
  
  class func stepNote(var currentNote: Int8, destinationNote: Int8, chordScale: Int8[]) -> Int8 {
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
  
  class func melodyNotes(#startNote: Int8, destinationNote: Int8, beats: Float, scale: Int8[]) -> MelodyNote[] {
    var rhythm = generateRhythm(beats: beats)
    
    var currentNote = startNote
    var notes = MelodyNote[]()
    
    // Don't hit the down beat. Instead, play an approach pattern
    if rhythm.count >= 2 && randomNumberInclusive(0, 4) == 0 {
      let aNotes = approachNotes(currentNote, scaleAbove: stepNote(currentNote, destinationNote: currentNote+8, chordScale: scale), scaleBelow: stepNote(currentNote, destinationNote: currentNote-8, chordScale: scale))
      let approachNote = aNotes.randomElement().note
      notes.append((approachNote, rhythm[0]))
      
      rhythm = Array(rhythm[1..rhythm.count])
    }
    
    for duration in rhythm {
      notes.append((currentNote, duration))
      if randomNumberInclusive(0, 19) >= 3 {
        // 85% chance of picking a new note
        currentNote = stepNote(currentNote, destinationNote: destinationNote, chordScale: scale)
      }
    }
    return notes
  }
  
  class func generateRhythm(#beats: Float) -> Float[] {
    if beats == 1 {
      let array: Float[][] = [
        [ 1.0 ],
        [ 1.0 ],
        [ 0.07, 0.93 ],
        [ 0.66, 0.34 ],
        [ 0.33, 0.33, 0.34 ],
        [ 0.3, 0.27, 0.23, 0.2 ]
      ]
      return array.randomElement()
    } else if beats == 2 {
      let array: Float[][] = [
        [ 2.0 ],
        [ 2.0 ],
        [ 1, 1 ],
        [ 1.6, 0.4 ],
        [ 0.07, 1.93 ],
        [ 0.4, 1.1, 0.5 ],
        [ 1, 0.66, 0.34 ],
        [ 0.66, 0.34, 1 ],
        [ 0.66, 0.34, 0.66, 0.34 ]
      ]
      return array.randomElement()
    } else if beats == 4 {
      let array: Float[][] = [
        [ 4 ],
        [ 3, 1 ],
        [ 1, 3 ],
        [ 2, 2 ],
        [ 1, 1, 2 ],
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
    let randomOption = randomNumberInclusive(0, 3)
    
    if (randomOption <= pivot) {
      return lowHigh.low
    } else {
      return lowHigh.high
    }
  }
}

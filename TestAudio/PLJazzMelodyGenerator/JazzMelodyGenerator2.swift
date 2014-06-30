//
//  JazzMelodyGenerator2.swift
//  TestAudio
//
//  Created by Peter Livesey on 6/26/14.
//  Copyright (c) 2014 Peter Livesey. All rights reserved.
//

import Foundation

class JazzMelodyGenerator {
  
  class func generateMelodyMeasures(#chordMeasures: ChordMeasure[]) -> MelodyMeasure[] {
    return generateMelodyOutline(chordMeasures: chordMeasures)
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
    measures.append(MelodyMeasure(notes: notes))
    
    return measures
  }
  
  class func nextNotes(#currentNote: Int8, beats: Float, chord: ChordData, destinationChord: ChordData) -> (melody: MelodyNote[], newCurrent: Int8) {
    let index = randomNumberInclusive(0, destinationChord.importantScaleIndexes.count-1)
    let zeroBasedNote = destinationChord.mainChordScale[destinationChord.importantScaleIndexes[index]]
    let lowHigh = surroundingNotes(currentNote, zeroBasedDestination: zeroBasedNote)
    let destination = selectDestination(lowHigh, currentNote:currentNote)
    println("Chord: \(MusicUtil.noteToString(destinationChord.baseNote%12)) destinationNote: \(MusicUtil.noteToString(destination%12)) chosen from scale: \(destinationChord.mainChordScale)")
    
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
    var upwardDirection = false
    for _ in 0..number {
      notes.append((note: currentNote, beats: beatsPerNote))
      currentNote = stepNote(currentNote, destinationNote: destinationNote, chordScale: chordScale)
    }
    return notes
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

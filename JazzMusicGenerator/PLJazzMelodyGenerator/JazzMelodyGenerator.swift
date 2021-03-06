//
//  JazzMelodyGenerator2.swift
//  TestAudio
//
//  Created by Peter Livesey on 6/26/14.
//  Copyright (c) 2014 Peter Livesey. All rights reserved.
//

import Foundation

// TODO: Should be class constants
let MELODY_HIGH = 112
let MELODY_LOW = 64

public class JazzMelodyGenerator {
  
  class func generateMelodyMeasuresFromChordMeasures(
    chordMeasures: [ChordMeasure],
    startingNote: Int,
    endingNote: Int,
    rhythm: [RhythmMeasure],
    solo: Bool) -> [ChordNoteMeasure] {
      let outline = generateMelodyOutlineFromChordMeasures(chordMeasures, startingNote: startingNote)
      return generateMelodyFromChordMeasures(chordMeasures,
        melodyOutline: outline,
        endingNote: endingNote,
        rhythm: rhythm,
        solo: solo)
  }
  
  public class func generateFinalRestingMeasure(closeToEndNote endNote: Int, chord: ChordData) -> ChordNoteMeasure {
    var scale: [Int] = chord.importantScaleIndexes.map {
      index in
      return chord.mainChordScale[index]
    }
    scale = MusicUtil.zeroBasedScale(scale)
    var restingNote = MusicUtil.closestNoteToNote(endNote, fromScale: scale).note
    
    return ChordNoteMeasure(notes: [ChordNote(note: restingNote, beats: 4)])
  }
  
  // Private
  
  class func generateMelodyOutlineFromChordMeasures(chordMeasures: [ChordMeasure], startingNote: Int) -> [ChordNoteMeasure] {
    
    // Find first note
    let firstChord = chordMeasures[0].chords[0].chord
    var scale: [Int] = firstChord.importantScaleIndexes.map {
      index in
      return firstChord.mainChordScale[index]
    }
    scale = MusicUtil.zeroBasedScale(scale)
    var currentNote = MusicUtil.closestNoteToNote(startingNote, fromScale: scale).note
    
    var measures = [ChordNoteMeasure]()
    
    for (measureIndex, chordMeasure) in enumerate(chordMeasures) {
      var notes = [ChordNote]()
      for (chordIndex, chord) in enumerate(chordMeasure.chords) {
        var destinationChordOp = MusicUtil.findNextChordInMeaures(chordMeasures, measureIndex: measureIndex, chordIndex: chordIndex)
        var iterations = 1
        if chord.beats == 4 {
          iterations = 2
        }
        if let destinationChord = destinationChordOp {
          for iteration in 0..<iterations {
            var actualDestination = destinationChord
            if chord.beats == 4 && iteration == 0 {
              actualDestination = chord.chord
            }
            let next = nextNotes(currentNote: currentNote, destinationChord: actualDestination)
            currentNote = next.newCurrent
            notes.extend(next.melody)
          }
        } else {
          for _ in 0..<iterations {
            notes.append(ChordNote(notes: [currentNote], beats: 2))
          }
        }
      }
      measures.append(ChordNoteMeasure(notes: notes))
    }
    
    return measures
  }
  
  class func nextNotes(#currentNote: Int, destinationChord: ChordData) -> (melody: [ChordNote], newCurrent: Int) {
    let index = RandomHelpers.randomNumberInclusive(0, destinationChord.importantScaleIndexes.count-1)
    let zeroBasedNote = destinationChord.mainChordScale[destinationChord.importantScaleIndexes[index]]
    let lowHigh = surroundingNotes(currentNote, zeroBasedDestination: zeroBasedNote)
    let destination = selectDestination(lowHigh, currentNote:currentNote)
    let nextNotes: [ChordNote] = [ ChordNote(notes: [currentNote], beats: 2) ]
    return (nextNotes, destination)
  }
  
  class func generateMelodyFromChordMeasures(
    chordMeasures: [ChordMeasure],
    melodyOutline: [ChordNoteMeasure],
    endingNote: Int,
    rhythm: [RhythmMeasure],
    solo: Bool) -> [ChordNoteMeasure] {
      
      assert(chordMeasures.count == melodyOutline.count)
      assert(rhythm.count == chordMeasures.count)
      
      var measures = [ChordNoteMeasure]()
      
      for i in 0..<melodyOutline.count {
        let melodyMeasure = melodyOutline[i]
        let chordMeasure = chordMeasures[i]
        
        var notes = [ChordNote]()
        let measureRhythm = rhythm[i]
        
        assert(melodyMeasure.notes.count <= 2)
        
        for (noteIndex, note) in enumerate(melodyMeasure.notes) {
          let currentNote = note.note
          var destinationNote = MusicUtil.findNextNoteInMelody(melodyOutline, measureIndex: i, noteIndex: noteIndex)
          // We're at the end of the melody, so let's use the passed in param
          if destinationNote == -1 {
            destinationNote = endingNote
          }
          
          var chord = chordMeasure.chords[0].chord
          if (noteIndex == 1) {
            chord = MusicUtil.chordBeat3(chordMeasure)
          }
          
          var scale: [Int] = {
            if solo {
              if RandomHelpers.randomNumberInclusive(0, 1) == 0 {
                return chord.chordScale.randomElement()
              }
            } else {
              if RandomHelpers.randomNumberInclusive(0, 3) == 0 {
                return chord.chordScale.randomElement()
              }
            }
            return chord.mainChordScale
          }()
          
          if RandomHelpers.randomNumberInclusive(0, 1) == 1 {
            scale = chord.chordScale.randomElement()
          }
          
          let currentRhythm = measureRhythm.rhythms[noteIndex]
          
          if currentRhythm.count == 0 {
            // This is a rest
            notes.append(ChordNote(notes: [-1], beats: 2))
          } else {
            let melody = melodyNotes(startNote: currentNote, destinationNote: destinationNote, beats: 2, scale: scale, rhythm: currentRhythm)
            notes.extend(melody)
          }
        }
        
        measures.append(ChordNoteMeasure(notes: notes))
      }
      return measures
  }
  
  class func stepNote(var currentNote: Int, destinationNote: Int, chordScale: [Int]) -> Int {
    let upwardDirection = currentNote < destinationNote
    do {
      if (upwardDirection) {
        currentNote = MusicUtil.noteAbove(currentNote, scale: chordScale)
      } else {
        currentNote = MusicUtil.noteBelow(currentNote, scale: chordScale)
      }
    } while (currentNote == destinationNote)
    return currentNote
  }
  
  class func melodyNotes(#startNote: Int, var destinationNote: Int, beats: Float, scale: [Int], var rhythm: [Float]) -> [ChordNote] {
    
    var currentNote = startNote
    var notes = [ChordNote]()
    
    // Play an approach note at the end
    var lastNoteOp: ChordNote? = nil
    if rhythm.count >= 2 && RandomHelpers.randomNumberInclusive(0, 2) == 0 {
      let aNotes = MusicUtil.approachNotes(destinationNote, scaleAbove: MusicUtil.noteAbove(destinationNote, scale: scale), scaleBelow: MusicUtil.noteBelow(destinationNote, scale: scale))
      let approachNote = aNotes.randomElement().note
      lastNoteOp = ChordNote(note: approachNote, beats: rhythm[rhythm.count - 1])
      
      rhythm = Array(rhythm[0..<rhythm.count - 1])
      
      destinationNote = approachNote
    }
    
    // Don't hit the down beat. Instead, play an approach pattern
    if rhythm.count >= 2 && rhythm[0] <= 1 && RandomHelpers.randomNumberInclusive(0, 4) == 0 {
      let aNotes = MusicUtil.approachNotes(currentNote, scaleAbove: stepNote(currentNote, destinationNote: currentNote+8, chordScale: scale), scaleBelow: stepNote(currentNote, destinationNote: currentNote-8, chordScale: scale))
      let approachNote = aNotes.randomElement().note
      notes.append(ChordNote(note: approachNote, beats: rhythm[0]))
      
      rhythm = Array(rhythm[1..<rhythm.count])
    }
    
    let notesToPlay = MusicUtil.notesToDestination(destinationNote, fromStart: currentNote, numberOfNotes: rhythm.count, chordScale: scale)
    
    for (index, duration) in enumerate(rhythm) {
      notes.append(ChordNote(note: notesToPlay[index], beats: duration))
    }
    
    if let lastNote = lastNoteOp {
      notes.append(lastNote)
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
  class func surroundingNotes(currentNote: Int, var zeroBasedDestination: Int) -> (low: Int, high: Int) {
    while (zeroBasedDestination <= currentNote) {
      zeroBasedDestination += 12
    }
    if (zeroBasedDestination == currentNote) {
      return (zeroBasedDestination, zeroBasedDestination)
    } else {
      return (zeroBasedDestination - 12, zeroBasedDestination)
    }
  }
  
  class func selectDestination(lowHigh: (low: Int, high: Int), currentNote: Int) -> Int {
    // Check to see if its too low or high
    if (lowHigh.low < MELODY_LOW) {
      return lowHigh.high
    } else if (lowHigh.high > MELODY_HIGH) {
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

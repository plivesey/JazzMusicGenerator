//
//  MusicUtil+Transpose.swift
//  TestAudio
//
//  Created by Peter Livesey on 7/14/14.
//  Copyright (c) 2014 Peter Livesey. All rights reserved.
//

import Foundation

extension MusicUtil {
  
  class func transformedMelody(melody: [MelodyMeasure], fitToChords chords: [ChordMeasure]) -> [MelodyMeasure] {
    var index = 0
    return melody.map {
      measure in
      let chordMeasure = chords[index++]
      return MusicUtil.transformMeasure(measure, fitToChords: chordMeasure)
    }
  }
  
  class func invertedMelody(melody: [MelodyMeasure]) -> [MelodyMeasure] {
    var maxValue: Int = Int.min
    var minValue: Int = Int.max
    for measure in melody {
      for note in measure.notes {
        if note.note > maxValue {
          maxValue = note.note
        }
        if note.note < minValue {
          minValue = note.note
        }
      }
    }
    
    let measures: [MelodyMeasure] = melody.map {
      measure in
      return self.invertMeasure(measure, max: maxValue, min: minValue)
    }
    return measures
  }
  
  class func invertMeasure(measure: MelodyMeasure, max: Int, min: Int) -> MelodyMeasure {
    let notes: [MelodyNote] = measure.notes.map {
      note in
      // Max is 10, min is 5
      // Note is 9 should go to 6
      // 5 + 10 - 9 = max + min - value
      return (max - note.note + min, note.beats)
    }
    return MelodyMeasure(notes: notes)
  }
  
  class func transformMeasure(measure: MelodyMeasure, fitToChords chordMeasure: ChordMeasure) -> MelodyMeasure {
    var beats: Float = 0
    var previousNote: Int = -1
    let notes: [MelodyNote] = measure.notes.map {
      note in
      var chord = chordMeasure.chords[0].chord
      if (beats >= 2) {
        chord = chordBeat3(chordMeasure)
      }
      // Default to current note
      var newNote = note.note
      if newNote != previousNote {
        // Let's put it in the right scale
        // First, pick a scale
        let scale = MusicUtil.zeroBasedScale(chord.chordScale.randomElement())
        newNote = MusicUtil.closestNoteToNote(newNote, fromScale: scale).note
        
        if newNote == previousNote {
          // We don't want a repeated note
          let above = noteAbove(newNote, scale: scale)
          let below = noteBelow(newNote, scale: scale)
          
          if above - newNote == newNote - below {
            if RandomHelpers.randomNumberInclusive(0, 1) == 1 {
              newNote = above
            } else {
              newNote = below
            }
          } else if above - newNote > newNote - below {
            newNote = below
          } else {
            newNote = above
          }
        }
      }
      
      previousNote = newNote
      beats += note.beats
      
      return (newNote, note.beats)
    }
    return MelodyMeasure(notes: notes)
  }
  
  class func transposeMelody(melody: [MelodyMeasure], delta: Int) -> [MelodyMeasure] {
    return melody.map {
      measure in
      let notes: [MelodyNote] = measure.notes.map {
        note in
        return (note.note + delta, note.beats)
      }
      return MelodyMeasure(notes: notes)
    }
  }
}

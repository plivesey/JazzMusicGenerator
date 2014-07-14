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
  
  class func transformMeasure(measure: MelodyMeasure, fitToChords chordMeasure: ChordMeasure) -> MelodyMeasure {
    var beats: Float = 0
    var previousNote: Int8 = -1
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
      }
      
      beats += note.beats
      
      return (newNote, note.beats)
    }
    return MelodyMeasure(notes: notes)
  }
  
  class func transposeMelody(melody: [MelodyMeasure], delta: Int8) -> [MelodyMeasure] {
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

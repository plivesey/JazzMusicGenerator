//
//  MusicUtil+Finder.swift
//  TestAudio
//
//  Created by Peter Livesey on 6/30/14.
//  Copyright (c) 2014 Peter Livesey. All rights reserved.
//

import Foundation

extension MusicUtil {
  
  class func findNextNoteInMelody(melody: [ChordNoteMeasure], measureIndex: Int, noteIndex: Int) -> Int {
    let currentMeasure = melody[measureIndex]
    if noteIndex + 1 < currentMeasure.notes.count {
      return currentMeasure.notes[noteIndex + 1].note
    }
    if measureIndex+1 < melody.count {
      let measure = melody[measureIndex + 1]
      return measure.notes[0].note
    }
    return -1
  }
  
  class func findNextChordInMeaures(measures: [ChordMeasure], measureIndex: Int, chordIndex: Int) -> ChordData? {
    let current = measures[measureIndex]
    if chordIndex + 1 < current.chords.count {
      return current.chords[chordIndex + 1].chord
    }
    if measureIndex + 1 < measures.count {
      let measure = measures[measureIndex + 1]
      return measure.chords[0].chord
    }
    return nil
  }
  
  class func chordBeat3(chordMeasure: ChordMeasure) -> ChordData {
    var currentBeats: Float = 0
    for chord in chordMeasure.chords {
      currentBeats += chord.beats
      if (currentBeats > 2) {
        return chord.chord
      }
    }
    return chordMeasure.chords[0].chord
  }

}

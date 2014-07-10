//
//  RhythmSectionGenerator.swift
//  TestAudio
//
//  Created by Peter Livesey on 7/2/14.
//  Copyright (c) 2014 Peter Livesey. All rights reserved.
//

import Foundation

// Shouldn't be global
let CHORD_TRANSPOSITION: Int8 = 48

class RhythmSectionGenerator {
  
  class func rhythmSectionFromChords(chords: ChordMeasure[]) -> ChordNoteMeasure[] {
    var measures = ChordNoteMeasure[]()
    for measure in chords {
      var notes = ChordNote[]()
      for chord in measure.chords {
        let rhythm = rhythms(chord.beats).randomElement()
        let chordNotes = chord.chord.chordNotes.map {
          x in x + CHORD_TRANSPOSITION
        }
        for part in rhythm {
          if part.rest {
            notes.append(ChordNote(notes: [], beats: part.beats))
          } else {
            notes.append(ChordNote(notes: chordNotes, beats: part.beats))
          }
        }
      }
      measures.append(ChordNoteMeasure(notes: notes))
    }
    return measures
  }
  
  class func rhythms(beats: Float) -> RhythmPart[][] {
    if beats == 2 {
      return [
        [RhythmPart(2, false)],
        [RhythmPart(1, true), RhythmPart(1, false)],
        [RhythmPart(1, false), RhythmPart(1, false)],
        [RhythmPart(0.66, false), RhythmPart(0.34, false), RhythmPart(0.66, true), RhythmPart(0.34, false)]
      ]
    } else {
      return [
        [RhythmPart(4, false)],
        [RhythmPart(3, false), RhythmPart(1, false)],
        [RhythmPart(1, true), RhythmPart(1, false), RhythmPart(1, true), RhythmPart(1, false)],
        [RhythmPart(1.5, false), RhythmPart(1.5, false), RhythmPart(0.5, false)],
        [RhythmPart(1, true), RhythmPart(0.5, false), RhythmPart(0.5, false), RhythmPart(1, true), RhythmPart(1, false)]
      ]
    }
  }
  
  struct RhythmPart {
    let beats: Float
    let rest: Bool
    
    init(_ beats: Float, _ rest: Bool) {
      self.beats = beats
      self.rest = rest
    }
  }
}

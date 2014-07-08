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
        [RhythmPart(beats: 2, rest: false)],
        [RhythmPart(beats: 1, rest: true), RhythmPart(beats: 1, rest: false)],
        [RhythmPart(beats: 1, rest: false), RhythmPart(beats: 1, rest: false)],
        [RhythmPart(beats: 0.6, rest: false), RhythmPart(beats: 0.4, rest: false), RhythmPart(beats: 0.6, rest: true), RhythmPart(beats: 0.4, rest: false)]
      ]
    } else {
      return [
        [RhythmPart(beats: 4, rest: false)],
        [RhythmPart(beats: 3, rest: false), RhythmPart(beats: 1, rest: false)],
        [RhythmPart(beats: 1, rest: true), RhythmPart(beats: 1, rest: false), RhythmPart(beats: 1, rest: true), RhythmPart(beats: 1, rest: false)],
        [RhythmPart(beats: 1.5, rest: false), RhythmPart(beats: 1.5, rest: false), RhythmPart(beats: 0.5, rest: false)],
        [RhythmPart(beats: 1, rest: true), RhythmPart(beats: 0.5, rest: false), RhythmPart(beats: 0.5, rest: false), RhythmPart(beats: 1, rest: true), RhythmPart(beats: 1, rest: false)]
      ]
    }
  }
  
  struct RhythmPart {
    let beats: Float
    let rest: Bool
  }
}

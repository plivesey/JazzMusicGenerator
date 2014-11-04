//
//  RhythmSectionGenerator.swift
//  TestAudio
//
//  Created by Peter Livesey on 7/2/14.
//  Copyright (c) 2014 Peter Livesey. All rights reserved.
//

import Foundation

// Shouldn't be global
let CHORD_TRANSPOSITION: Int = 54

public class RhythmSectionGenerator {
  
  public class func rhythmSectionFromChords(chords: [ChordMeasure]) -> [ChordNoteMeasure] {
    var measures = [ChordNoteMeasure]()
    let bassNote = CHORD_TRANSPOSITION
    for measure in chords {
      var notes = [ChordNote]()
      for chord in measure.chords {
        let rhythm = rhythms(chord.beats).randomElement()
        let chordNotes = chord.chord.chordNotes
        for part in rhythm {
          if part.rest {
            notes.append(ChordNote(notes: [], beats: part.beats))
          } else {
            notes.append(ChordNote(notes: chordNotes, beats: part.beats))
          }
        }
      }
      let voicedNotes: [ChordNote] = notes.map {
        chordNote in
        return ChordVoicer.voicedChordFromChordNote(chordNote, closeTo: bassNote)
      }
      measures.append(ChordNoteMeasure(notes: voicedNotes))
    }
    return measures
  }
  
  public class func endingRhythmSectionForChord(chord: ChordMeasure) -> ChordNoteMeasure {
    let chordNotes = chord.chords[0].chord.chordNotes
    let chordNote = ChordNote(notes: chordNotes, beats: 4)
    let voicedChordNote = ChordVoicer.voicedChordFromChordNote(chordNote, closeTo: CHORD_TRANSPOSITION)
    return ChordNoteMeasure(notes: [voicedChordNote])
  }
  
  class func rhythms(beats: Float) -> [[RhythmPart]] {
    if beats == 2 {
      return [
        [RhythmPart(2, false)],
        [RhythmPart(1, true), RhythmPart(1, false)],
        [RhythmPart(1, false), RhythmPart(1, false)],
        [RhythmPart(1.66, false), RhythmPart(0.34, false)],
        [RhythmPart(0.66, true), RhythmPart(1, false), RhythmPart(0.34, true)],
        [RhythmPart(0.66, false), RhythmPart(0.66, false), RhythmPart(0.34, true), RhythmPart(0.34, false)]
      ]
    } else {
      var fourBeatRhythms = [
        [RhythmPart(4, false)],
        [RhythmPart(3, false), RhythmPart(1, false)],
        [RhythmPart(1, true), RhythmPart(1, false), RhythmPart(1, true), RhythmPart(1, false)],
        [RhythmPart(1.5, false), RhythmPart(1.5, false), RhythmPart(0.5, false)]
      ]
      let twoBeatRhythms = rhythms(2)
      for r1 in twoBeatRhythms {
        for r2 in twoBeatRhythms {
          let fourBeat = r1 + r2
          fourBeatRhythms.append(fourBeat)
        }
      }
      
      return fourBeatRhythms
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

//
//  DrumGenerator.swift
//  TestAudio
//
//  Created by Peter Livesey on 7/7/14.
//  Copyright (c) 2014 Peter Livesey. All rights reserved.
//

import Foundation

// TODO: These shouldn't be global
let bass: Int8 = 36
let snare: Int8 = 38
let ride: Int8 = 51
let highHat: Int8 = 44

class DrumGenerator {
  
  class func generateDrums(#numberOfMeasures: Int) -> ChordNoteMeasure[] {
    var measures = ChordNoteMeasure[]()
    for _ in 0..numberOfMeasures {
      let notes = drumMeasureNotes()
      let measure = ChordNoteMeasure(notes: notes)
      measures.append(measure)
    }
    return measures
  }
  
  class func drumMeasureNotes() -> ChordNote[] {
    var notes = ChordNote[]()
    notes.append(ChordNote(notes: [ ride, bass ], beats: 0.66))
    notes.append(ChordNote(notes: [ bass ], beats: 0.34))
    
    notes.append(ChordNote(notes: [ highHat, ride, snare ], beats: 0.66))
    notes.append(ChordNote(notes: [ ride, snare ], beats: 0.34))
    
    notes.append(ChordNote(notes: [ ride, bass ], beats: 0.66))
    notes.append(ChordNote(notes: [ bass ], beats: 0.34))
    
    notes.append(ChordNote(notes: [ highHat, ride, snare ], beats: 0.66))
    notes.append(ChordNote(notes: [ ride, snare ], beats: 0.34))
    
    return notes
  }
}

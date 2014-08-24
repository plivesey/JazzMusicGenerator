//
//  MelodyMeasure.swift
//  TestAudio
//
//  Created by Peter Livesey on 6/19/14.
//  Copyright (c) 2014 Peter Livesey. All rights reserved.
//

import Foundation

struct ChordNoteMeasure {
  let notes: [ChordNote]
}

struct ChordNote {
  let notes: [Int]
  let beats: Float
  
  var note: Int {
    get {
      return notes[0]
    }
  }
  
  init(notes: [Int], beats: Float) {
    assert(notes.count > 0)
    self.notes = notes
    self.beats = beats
  }
  
  init(note: Int, beats: Float) {
    self.notes = [note]
    self.beats = beats
  }
}

//
//  MelodyMeasure.swift
//  TestAudio
//
//  Created by Peter Livesey on 6/19/14.
//  Copyright (c) 2014 Peter Livesey. All rights reserved.
//

import Foundation

public struct ChordNoteMeasure {
  let notes: [ChordNote]
}

public struct ChordNote {
  let notes: [Int]
  let beats: Float
  
  var note: Int {
    get {
      if notes.count > 0 {
        return notes[0]
      } else {
        return -1
      }
    }
  }
  
  init(notes: [Int], beats: Float) {
    self.notes = notes
    self.beats = beats
  }
  
  init(note: Int, beats: Float) {
    self.notes = [note]
    self.beats = beats
  }
}

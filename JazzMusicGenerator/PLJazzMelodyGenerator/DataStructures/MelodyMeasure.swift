//
//  MelodyMeasure.swift
//  TestAudio
//
//  Created by Peter Livesey on 6/19/14.
//  Copyright (c) 2014 Peter Livesey. All rights reserved.
//

import Foundation

public struct ChordNoteMeasure {
  public let notes: [ChordNote]
}

public struct ChordNote {
  public let notes: [Int]
  public let beats: Float
  
  public var note: Int {
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

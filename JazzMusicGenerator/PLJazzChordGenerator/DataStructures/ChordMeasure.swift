//
//  ChordMeasure.swift
//  TestAudio
//
//  Created by Peter Livesey on 6/16/14.
//  Copyright (c) 2014 Peter Livesey. All rights reserved.
//

public struct ChordMeasure: Printable {
  public let chords: [(chord: ChordData, beats: Float)]
  
  public var description: String {
  get {
    var text = ""
    for (chordIndex, chord) in enumerate(chords) {
      if chordIndex > 0 {
        
        text += "- "
      }
      text += "\(chord.chord) "
    }
    return text
  }}
}

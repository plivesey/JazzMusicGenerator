//
//  ChordMeasure.swift
//  TestAudio
//
//  Created by Peter Livesey on 6/16/14.
//  Copyright (c) 2014 Peter Livesey. All rights reserved.
//

struct ChordMeasure: Printable {
  let chords: [(chord: ChordData, beats: Float)]
  
  var description: String {
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

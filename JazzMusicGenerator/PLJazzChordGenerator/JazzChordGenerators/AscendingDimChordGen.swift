//
//  AscendingDimChordGen.swift
//  TestAudio
//
//  Created by Peter Livesey on 7/10/14.
//  Copyright (c) 2014 Peter Livesey. All rights reserved.
//

import Foundation

class AscendingDimChordGen: ChordGenProtocol {
  
  func canStartOnChord(chord: ChordData, numberOfMeasures: Int) -> Bool {
    return chord.type == ChordType.Major7
  }
  
  func generateNextChords(#startingChord: ChordData, numberOfMeasures: Int, scale: [(note: Int, type: ChordType)])
    -> (chords:[ChordMeasure], nextChord: ChordData) {
      let key = ChordFactory.CBasedNote(rawValue: startingChord.baseNote)!
      let chords = [
        startingChord,
        ChordFactory.sharpiDimChord(key: key),
        ChordFactory.iiChord(key: key),
        ChordFactory.sharpiiDimChord(key: key)
      ]
      let destination = ChordFactory.iiiChord(key: key)
      
      let chordsWithBeats: [(ChordData, beats: Int)] = chords.map {
        chord in
        return (chord, beats: 1)
      }
      
      let measures = JazzChordGenerator.chordMeasuresFromChords(chordsWithBeats, measures: numberOfMeasures)
      return (measures, destination)
  }
}

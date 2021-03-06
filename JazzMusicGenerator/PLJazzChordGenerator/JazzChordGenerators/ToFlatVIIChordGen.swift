//
//  ToFlatVIIChordGen.swift
//  TestAudio
//
//  Created by Peter Livesey on 7/10/14.
//  Copyright (c) 2014 Peter Livesey. All rights reserved.
//

import Foundation

class ToFlatVIIChordGen: ChordGenProtocol {
  
  func canStartOnChord(chord: ChordData, numberOfMeasures: Int) -> Bool {
    // If it's a dom7, then it'll play the A train chords
    return chord.type == ChordType.Major7 || chord.type == ChordType.Dom7
  }
  
  func generateNextChords(#startingChord: ChordData, numberOfMeasures: Int, scale: [(note: Int, type: ChordType)])
    -> (chords:[ChordMeasure], nextChord: ChordData) {
      let key = ChordFactory.CBasedNote(rawValue: (startingChord.baseNote + 10) % 12)!
      let chords = [
        startingChord,
        startingChord,
        ChordFactory.iiChordMajorABForm(key: key),
        ChordFactory.VChordMinorABForm(key: key)
      ]
      let destination = ChordFactory.IChordMajor9(key: key)
      
      let chordsWithBeats: [(ChordData, beats: Int)] = chords.map {
        chord in
        return (chord, beats: 1)
      }
      
      let measures = JazzChordGenerator.chordMeasuresFromChords(chordsWithBeats, measures: numberOfMeasures)
      return (measures, destination)
  }
}

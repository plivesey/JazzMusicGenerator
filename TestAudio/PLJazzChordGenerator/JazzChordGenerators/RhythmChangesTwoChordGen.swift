//
//  RhythmChangesTwoChordGen.swift
//  TestAudio
//
//  Created by Peter Livesey on 7/10/14.
//  Copyright (c) 2014 Peter Livesey. All rights reserved.
//

import Foundation

class RhythmChangesTwoChordGen: ChordGenProtocol {
  
  func canStartOnChord(chord: ChordData, numberOfMeasures: Int) -> Bool {
    return chord.type == ChordType.Minor7
  }
  
  func generateNextChords(#startingChord: ChordData, numberOfMeasures: Int, scale: [(note: Int, type: ChordType)])
    -> (chords:[ChordMeasure], nextChord: ChordData) {
      let key = ChordFactory.CBasedNote.fromRaw((startingChord.baseNote + 8) % 12)!
      let chords = [
        startingChord, // This is actually the iii
        ChordFactory.viChord(key: key),
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

//
//  RhythmChangesOneChordGen.swift
//  TestAudio
//
//  Created by Peter Livesey on 7/10/14.
//  Copyright (c) 2014 Peter Livesey. All rights reserved.
//

import Foundation

class RhythmChangesOneChordGen: ChordGenProtocol {
  
  func canStartOnChord(chord: ChordData, numberOfMeasures: Int) -> Bool {
    return chord.type == ChordType.Major7
  }
  
  func generateNextChords(#startingChord: ChordData, numberOfMeasures: Int, scale: [(note: Int8, type: ChordType)])
    -> (chords:[ChordMeasure], nextChord: ChordData) {
      let key = ChordFactory.CBasedNote.fromRaw(startingChord.baseNote)!
      let chords = [
        startingChord,
        ChordFactory.viChord(key: key),
        ChordFactory.iiChordMajorABForm(key: key),
        ChordFactory.VChordMinorABForm(key: key)
      ]
      let destinations: [(ChordData, weight: Int)] = [
        (ChordFactory.IChordMajor9(key: key), 1),
        (ChordFactory.iiiChord(key: key), 1)
        ]
      let destination = RandomHelpers.randomElementFromWeightedList(destinations)
      
      
      let chordsWithBeats: [(ChordData, beats: Int)] = chords.map {
        chord in
        return (chord, beats: 1)
      }
      
      let measures = JazzChordGenerator.chordMeasuresFromChords(chordsWithBeats, measures: numberOfMeasures)
      return (measures, destination)
  }
}

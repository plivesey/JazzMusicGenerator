//
//  TwoFiveTwoFiveEndingChordGen.swift
//  TestAudio
//
//  Created by Peter Livesey on 10/26/14.
//  Copyright (c) 2014 Peter Livesey. All rights reserved.
//

import Foundation

class TwoFiveTwoFiveEndingChordGen: ChordEndingGenProtocol {
  
  func canGenerateEndingStartingOnChord(chord: ChordData, numberOfMeasures: Int, destination: ChordData) -> Bool {
    return true
  }
  
  func generateEndingChords(#startingChord: ChordData, numberOfMeasures: Int, destination: ChordData) -> [ChordMeasure] {
    
    var currentChord = startingChord
    var keyInt = scale.randomElement().note
    var chords = [
      ChordFactory.iiChordMinorABForm(key: .D),
      ChordFactory.VChordMinorABForm(key: .D),
      ChordFactory.iiChordMajorABForm(key: .C),
      ChordFactory.VChordMajorABForm(key: .C)
    ]
    
    let chordsWithBeats: [(ChordData, beats: Int)] = chords.map {
      chord in
      return (chord, beats: 1)
    }
    
    return JazzChordGenerator.chordMeasuresFromChords(chordsWithBeats, measures: numberOfMeasures)
  }
}

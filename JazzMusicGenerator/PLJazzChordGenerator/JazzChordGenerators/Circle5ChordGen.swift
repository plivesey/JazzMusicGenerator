//
//  ATrainChordGen.swift
//  TestAudio
//
//  Created by Peter Livesey on 7/19/14.
//  Copyright (c) 2014 Peter Livesey. All rights reserved.
//

import Foundation

class Circle5ChordGen: ChordGenProtocol {
  
  func canStartOnChord(chord: ChordData, numberOfMeasures: Int) -> Bool {
    return true
  }
  
  func generateNextChords(#startingChord: ChordData, numberOfMeasures: Int, scale: [(note: Int, type: ChordType)])
    -> (chords:[ChordMeasure], nextChord: ChordData) {
      
      var currentChord = startingChord
      var keyInt = scale.randomElement().note
      var chords: [ChordData] = [ startingChord ]
      for _ in 0..<3 {
        keyInt = (keyInt + 5) % 12
        currentChord = ChordFactory.VChordMajorABForm(key: ChordFactory.CBasedNote(rawValue: keyInt)!)
        chords.append(currentChord)
      }
      
      let finalKey = ChordFactory.CBasedNote(rawValue: keyInt)!
      let destination = [
        ChordFactory.IChordMajor9(key: finalKey),
        ChordFactory.IChord(key: finalKey),
        ChordFactory.iChordMinor9(key: finalKey),
        ChordFactory.flatVISharp11(key: finalKey),
        ChordFactory.viChord(key: finalKey),
        ].randomElement()
      
      let chordsWithBeats: [(ChordData, beats: Int)] = chords.map {
        chord in
        return (chord, beats: 1)
      }
      
      let measures = JazzChordGenerator.chordMeasuresFromChords(chordsWithBeats, measures: numberOfMeasures)
      return (measures, destination)
  }
}

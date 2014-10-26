//
//  TwoFiveOneChordGen.swift
//  TestAudio
//
//  Created by Peter Livesey on 7/10/14.
//  Copyright (c) 2014 Peter Livesey. All rights reserved.
//

import Foundation

class TwoFiveOneChordGen: ChordGenProtocol, ChordEndingGenProtocol {
  
  func canStartOnChord(chord: ChordData, numberOfMeasures: Int) -> Bool {
    return true
  }
  
  func canGenerateEndingStartingOnChord(chord: ChordData, numberOfMeasures: Int, destination: ChordData) -> Bool {
    return true
  }
  
  func generateEndingChords(#startingChord: ChordData, numberOfMeasures: Int, destination: ChordData) -> [ChordMeasure] {
      let baseNote = destination.baseNote
      let key = ChordFactory.CBasedNote(rawValue: baseNote)!
      return generateChords(startingChord: startingChord, numberOfMeasures: numberOfMeasures, key: key, type: destination.type).chords
  }
  
  func generateNextChords(#startingChord: ChordData, numberOfMeasures: Int, scale: [(note: Int, type: ChordType)]) -> (chords:[ChordMeasure], nextChord: ChordData) {
    // Don't go to one
    var possibleDestinations = Array(scale[1..<scale.count])
    
    // Make Dom7 into Major7
    // Make Major minor into minor
    possibleDestinations = possibleDestinations.map {
      scaleNote in
      switch scaleNote.type {
      case ChordType.Dom7:
        return (scaleNote.note, ChordType.Major7)
      case ChordType.MinorMajor7:
        return (scaleNote.note, ChordType.Minor7)
      default:
        return scaleNote
      }
    }
    
    // Filter out everything which isn't major or minor
    possibleDestinations = possibleDestinations.filter({
      scaleNote in
      return scaleNote.type == ChordType.Major7 || scaleNote.type == ChordType.Minor7
      })
    
    let oneNote = possibleDestinations.randomElement()
    
    let key = ChordFactory.CBasedNote(rawValue: oneNote.note)!
    
    return generateChords(startingChord: startingChord, numberOfMeasures: numberOfMeasures, key: key, type: oneNote.type)
  }
  
  func generateChords(#startingChord: ChordData, numberOfMeasures: Int, key: ChordFactory.CBasedNote, type: ChordType) -> (chords:[ChordMeasure], nextChord: ChordData) {
    
    if (type == ChordType.Major7) {
      // TODO: Sometimes go to 6
      let one = ChordFactory.IChordMajor9(key: key)
      let two = ChordFactory.iiChordMajorABForm(key: key)
      let five = ChordFactory.VChordMajorABForm(key: key)
      return (chordsFromStart(startingChord, two: two, five: five, numberOfMeasures: numberOfMeasures), one)
    } else {
      // TODO: Sometimes go to other ones
      let one = ChordFactory.iChordMinor9(key: key)
      let two = ChordFactory.iiChordMinorABForm(key: key)
      let five = ChordFactory.VChordMinorABForm(key: key)
      return (chordsFromStart(startingChord, two: two, five: five, numberOfMeasures: numberOfMeasures), one)
    }
  }
  
  func chordsFromStart(start: ChordData, two: ChordData, five: ChordData, numberOfMeasures: Int) -> [ChordMeasure] {
    let chords = [
      (start, beats: 2),
      (two, beats: 1),
      (five, beats: 1)
    ]
    return JazzChordGenerator.chordMeasuresFromChords(chords, measures: numberOfMeasures)
  }
}

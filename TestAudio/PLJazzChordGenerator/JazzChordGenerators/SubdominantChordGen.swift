//
//  SubdominantChordGen.swift
//  TestAudio
//
//  Created by Peter Livesey on 7/19/14.
//  Copyright (c) 2014 Peter Livesey. All rights reserved.
//

import Foundation

class SubdominantChordGen: ChordGenProtocol {
  
  func canStartOnChord(chord: ChordData, numberOfMeasures: Int) -> Bool {
    return true
  }
  
  func generateNextChords(#startingChord: ChordData, numberOfMeasures: Int, scale: [(note: Int8, type: ChordType)])
    -> (chords:[ChordMeasure], nextChord: ChordData) {
      
      // Don't go to one
      var possibleDestinations = Array(scale[1..<scale.count])
      
      // Make Dom7 into Major7
      // Make Major minor into minor
      // Make dim and partially into minor
      possibleDestinations = possibleDestinations.map {
        scaleNote in
        switch scaleNote.type {
        case ChordType.Dom7:
          return (scaleNote.note, ChordType.Major7)
        case ChordType.MinorMajor7, ChordType.DimFully, ChordType.DimPartial:
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
      
      let key = ChordFactory.CBasedNote.fromRaw(oneNote.note)!
      
      if (oneNote.type == ChordType.Major7) {
        // TODO: Sometimes go to 6
        let one = ChordFactory.IChordMajor9(key: key)
        let five = ChordFactory.VChordMajorABForm(key: key)
        // Randomly do double on five or I/V
        var two = [ChordFactory.I9OverV(key: key), five].randomElement()
        return (chordsFromStart(startingChord, two: two, five: five, numberOfMeasures: numberOfMeasures), one)
      } else {
        // TODO: Sometimes go to other ones
        let one = ChordFactory.iChordMinor9(key: key)
        let five = ChordFactory.VChordMinorABForm(key: key)
        var two = [ChordFactory.i9OverV(key: key), five].randomElement()
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

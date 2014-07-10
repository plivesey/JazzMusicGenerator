//
//  TwoFiveOneChordGen.swift
//  TestAudio
//
//  Created by Peter Livesey on 7/10/14.
//  Copyright (c) 2014 Peter Livesey. All rights reserved.
//

import Foundation

class TwoFiveOneChordGen: ChordGenProtocol {
  
  func canStartOnChord(chord: ChordData, numberOfMeasures: Int) -> Bool {
    return true
  }
  
  func generateNextChords(#startingChord: ChordData, numberOfMeasures: Int, scale: [(note: Int8, type: ChordType)])
    -> (chords:[ChordMeasure], nextChord: ChordData) {
      
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
      
      var oneNote = possibleDestinations.randomElement()
      while (oneNote.note == startingChord.baseNote) {
        oneNote = possibleDestinations.randomElement()
      }
      
      let key = ChordFactory.CBasedNote.fromRaw(oneNote.note)!
      
      if (oneNote.type == ChordType.Major7) {
        // TODO: Sometimes go to 6
        let one = ChordFactory.IChordMajor9(key: key)
        let two = ChordFactory.iiChordMajorABForm(key: key)
        let five = ChordFactory.VChordMajorABForm(key: key)
        if (numberOfMeasures == 2) {
          let measure1 = ChordMeasure(chords: [(startingChord, 4)])
          let measure2 = ChordMeasure(chords: [(two, 2), (five, 2)])
          return ([measure1, measure2], one)
        } else {
          // Assume 4
          let measure1 = ChordMeasure(chords: [(startingChord, 4)])
          let measure2 = ChordMeasure(chords: [(startingChord, 4)])
          let measure3 = ChordMeasure(chords: [(two, 4)])
          let measure4 = ChordMeasure(chords: [(five, 4)])
          return ([measure1, measure2, measure3, measure4], one)
        }
      } else {
        // TODO: Sometimes go to other ones
        let one = ChordFactory.iChordMinor9(key: key)
        let two = ChordFactory.iiChordMinorABForm(key: key)
        let five = ChordFactory.VChordMinorABForm(key: key)
        if (numberOfMeasures == 2) {
          let measure1 = ChordMeasure(chords: [(startingChord, 4)])
          let measure2 = ChordMeasure(chords: [(two, 2), (five, 2)])
          return ([measure1, measure2], one)
        } else {
          // Assume 4
          let measure1 = ChordMeasure(chords: [(startingChord, 4)])
          let measure2 = ChordMeasure(chords: [(startingChord, 4)])
          let measure3 = ChordMeasure(chords: [(two, 4)])
          let measure4 = ChordMeasure(chords: [(five, 4)])
          return ([measure1, measure2, measure3, measure4], one)
        }
      }
  }
}

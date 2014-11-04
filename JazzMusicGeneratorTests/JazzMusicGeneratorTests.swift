//
//  JazzMusicGeneratorTests.swift
//  JazzMusicGeneratorTests
//
//  Created by Peter Livesey on 11/4/14.
//  Copyright (c) 2014 Peter Livesey. All rights reserved.
//

import UIKit
import XCTest

class JazzMusicGeneratorTests: XCTestCase {
  
  func testStressCrash() {
    for numberOfMeasures in stride(from: 0, through: 36, by: 8) {
      for key in stride(from: 0, through: 11, by: 4) {
        let chords = JazzChordGenerator.generateRandomChords(numMeasures: numberOfMeasures, key: key)
        XCTAssertEqual(chords.count, numberOfMeasures)
        
        for startNote in stride(from: 40, through: 100, by: 20) {
          let melody = SongComposer.generateMelodyForChordMeasures(chords, startNote: startNote, endNote: startNote)
          let solo = SongComposer.generateSoloSection(chords, startNote: startNote, endNote: startNote)
          XCTAssertEqual(melody.count, numberOfMeasures)
          XCTAssertEqual(solo.count, numberOfMeasures)
        }
        
        let rhythm = RhythmSectionGenerator.rhythmSectionFromChords(chords)
        XCTAssertEqual(rhythm.count, numberOfMeasures)
        
        let bass = BasslineGenerator.generateBasslineForChordMeasures(chords)
        XCTAssertEqual(bass.count, numberOfMeasures)
        
        let drums = DrumGenerator.generateDrums(numberOfMeasures: numberOfMeasures)
        XCTAssertEqual(drums.count, numberOfMeasures)
      }
    }
  }
}

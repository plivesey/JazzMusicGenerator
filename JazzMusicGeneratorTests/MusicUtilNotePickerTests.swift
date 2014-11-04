//
//  MusicUtilNotePickerTests.swift
//  JazzMusicGenerator
//
//  Created by Peter Livesey on 11/4/14.
//  Copyright (c) 2014 Peter Livesey. All rights reserved.
//

import Foundation
import XCTest

class MusicUtilNotePickerTests: XCTestCase {

  // MARK: - noteFromScaleTests
  
  func testNoteFromScale() {
    for scaleNote in 0..<11 {
      for destinationNote in 0..<100 {
        let closestNote = MusicUtil.noteFromScale(scaleNote, closestToNote: destinationNote)
        XCTAssertEqual(closestNote % 12, scaleNote)
        if destinationNote >= 6 {
          XCTAssertTrue(abs(destinationNote - closestNote) <= 6)
        } else {
          XCTAssertTrue(abs(destinationNote - closestNote) <= 6 || closestNote < 12)
        }
      }
    }
  }
}

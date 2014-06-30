//
//  MusicUtil.swift
//  TestAudio
//
//  Created by Peter Livesey on 6/29/14.
//  Copyright (c) 2014 Peter Livesey. All rights reserved.
//

import Foundation

class MusicUtil {
  
  // Input: Any positive number or -1
  // Output: A string representation of the note.
  class func noteToString(var note: Int8) -> String {
    note = note % 12
    switch note {
    case -1:
      return "rest"
    case 0:
      return "C"
    case 1:
      return "C#"
    case 2:
      return "D"
    case 3:
      return "Eb"
    case 4:
      return "E"
    case 5:
      return "F"
    case 6:
      return "F#"
    case 7:
      return "G"
    case 8:
      return "Ab"
    case 9:
      return "A"
    case 10:
      return "Bb"
    case 11:
      return "B"
    default:
      return "ERROR"
    }
  }
}

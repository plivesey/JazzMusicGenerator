//
//  ChordData.swift
//  TestAudio
//
//  Created by Peter Livesey on 6/16/14.
//  Copyright (c) 2014 Peter Livesey. All rights reserved.
//

import Foundation

struct ChordData {
  enum ChordType {
    case Major7
    case Minor7
    case Dom7
    case MinorMajor7
    case DimPartial
    case DimFully
  }
  let baseNote: Int
  let type: ChordType
  let root: Int
  
  func chordNotes() -> Int[] {
    var baseArray = Int[]()
    switch type {
    case .Major7:
      baseArray = [0, 4, 7, 11]
    case .Minor7:
      baseArray = [0, 3, 7, 10]
    case .Dom7:
      baseArray = [0, 4, 7, 10]
    case .MinorMajor7:
      baseArray = [0, 3, 7, 11]
    case .DimFully:
      baseArray = [0, 3, 6, 9]
    case .DimPartial:
      baseArray = [0, 3, 6, 10]
    }
    return baseArray.map {
      $0 + self.baseNote
    }
  }
  
  func description() -> String {
    var des = ""
    
    // Base note
    let note = baseNote % 12
    switch note {
    case 0:
      des += "C"
    case 1:
      des += "C#"
    case 2:
      des += "D"
    case 3:
      des += "D#"
    case 4:
      des += "E"
    case 5:
      des += "F"
    case 6:
      des += "F#"
    case 7:
      des += "G"
    case 8:
      des += "G#"
    case 9:
      des += "A"
    case 10:
      des += "Bb"
    case 11:
      des += "B"
    default:
      des += "ERROR"
    }
    
    // Type
    switch type {
    case .Major7:
      des += " maj7"
    case .Minor7:
      des += " m7"
    case .Dom7:
      des += " 7"
    case .MinorMajor7:
      des += " majmin7"
    case .DimFully:
      des += "°"
    case .DimPartial:
      des += "ø"
    }
    return des
  }
}

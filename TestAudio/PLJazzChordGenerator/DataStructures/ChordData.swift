//
//  ChordData.swift
//  TestAudio
//
//  Created by Peter Livesey on 6/16/14.
//  Copyright (c) 2014 Peter Livesey. All rights reserved.
//

import Foundation

enum ChordType {
  case Major7
  case Minor7
  case Dom7
  case MinorMajor7
  case DimPartial
  case DimFully
}

struct ChordData {
  
  let baseNote: Int8
  let type: ChordType
  // The notes of the chords in 3rds from bottom
  let chordScale: Int8[][]
  let importantScaleIndexes: Int[]
  let chordNotes: Int8[]
  let root: Int8
  
  var mainChordScale: Int8[] {
    get {
      return chordScale[0]
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
      des += "Eb"
    case 4:
      des += "E"
    case 5:
      des += "F"
    case 6:
      des += "F#"
    case 7:
      des += "G"
    case 8:
      des += "Ab"
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



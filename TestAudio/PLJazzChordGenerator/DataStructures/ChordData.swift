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

struct ChordData: Printable {
  
  // A number from 0-11 which represents a note.
  // 0 represents I
  let baseNote: Int8
  
  let type: ChordType
  
  // Recommended chord scales to use
  // The first element will be 0-11 and represent a note (usually equal to the baseNote)
  // The scale should always be ascending, so the other notes in the scale may go higher than 11
  let chordScale: Int8[][]
  
  // Important indexes for strong beats.
  // Use with the main chord scale to calculate these notes
  let importantScaleIndexes: Int[]
  
  // These notes should be played by any ryhthm section.
  // The first element will always be 0-11
  // The array should always be ascending
  let chordNotes: Int8[]
  
  // A number from 0-11 which represents the root of the chord
  // This is often equal to the base note, but may be different (as in D/A)
  // This note should be stressed in the base section
  // Note: This note may be higher than the baseNote but it does not mean it should be played that way
  let root: Int8
  
  // The main chord scale. Use this with the important scale indexes.
  var mainChordScale: Int8[] {
  get {
    return chordScale[0]
  }
  }
  
  /*
   * Initializers
   */
  
  init(baseNote: Int8, type: ChordType, chordScale: Int8[][], importantScaleIndexes: Int[], chordNotes: Int8[], root: Int8) {
    self.baseNote = baseNote
    self.type = type
    self.chordScale = chordScale
    self.importantScaleIndexes = importantScaleIndexes
    self.chordNotes = chordNotes
    self.root = root
    
    // Asserts
    assertLegitimateBaseNote(baseNote)
    for scale in chordScale {
      assertLegitimateScale(scale)
    }
    assertLegitimateScale(chordNotes)
    assertLegitimateBaseNote(root)
  }
  
  func assertLegitimateBaseNote(note: Int8) {
    assert(note >= 0 && note <= 11, "First note in chord scale out of range")
  }
  
  func assertLegitimateScale(scale: Int8[]) {
    assertLegitimateBaseNote(scale[0])
    for i in 0..scale.count {
      if (i+1 < scale.count) {
        assert(scale[i+1] > scale[i], "Scale is not strictly ascending")
      }
    }
  }
  
  // Assumes that the root is the base note (1st inversion)
  init(baseNote: Int8, type: ChordType, chordScale: Int8[][], importantScaleIndexes: Int[], chordNotes: Int8[]) {
    self.init(baseNote: baseNote, type: type, chordScale: chordScale, importantScaleIndexes: importantScaleIndexes, chordNotes: chordNotes, root: baseNote)
  }
  
  var description: String {
  get {
    var output = ""
    
    // Base note
    output += MusicUtil.noteToString(baseNote)
    
    // Type
    switch type {
    case .Major7:
      output += " maj7"
    case .Minor7:
      output += " m7"
    case .Dom7:
      output += " 7"
    case .MinorMajor7:
      output += " majmin7"
    case .DimFully:
      output += "°"
    case .DimPartial:
      output += "ø"
    }
    
    // TODO: Add root note
    
    return output
  }
  }
}



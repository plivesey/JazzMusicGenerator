//
//  ChordFactory.swift
//  TestAudio
//
//  Created by Peter Livesey on 6/18/14.
//  Copyright (c) 2014 Peter Livesey. All rights reserved.
//

import Foundation

class ChordFactory {
  /*
    Root position basic chords
  */
  
  class func IChord(#key: CBasedNote) -> ChordData {
    let bassNote = (CBasedNote.C.toRaw() + key.toRaw()) % 12
    let type = ChordType.Major7
    let chordScales = [
      noteArray([.C, .D, .E, .F, .G, .A, .B], key: key),
      noteArray([.C, .D, .Eb, .E, .F, .G, .A, .B ], key: key)
    ]
    let chord = noteArray([.C, .E, .G, .B], key: key)
    let important = [0, 2, 4, 6]
    return ChordData(baseNote: bassNote, type: type, chordScale: chordScales, importantScaleIndexes: important, chordNotes: chord, root: bassNote)
  }
  
  class func iiChord(#key: CBasedNote) -> ChordData {
    let bassNote = (CBasedNote.D.toRaw() + key.toRaw()) % 12
    let type = ChordType.Minor7
    let chordScales = [
      noteArray([.D, .E, .F, .G, .A, .B, .C], key: key),
      noteArray([.D, .E, .F, .G, .Ab, .A, .B, .C], key: key)
    ]
    let chord = noteArray([.D, .F, .A, .C], key: key)
    let important = [0, 2, 4, 6]
    return ChordData(baseNote: bassNote, type: type, chordScale: chordScales, importantScaleIndexes: important, chordNotes: chord, root: bassNote)
  }
  
  class func iiiChord(#key: CBasedNote) -> ChordData {
    let bassNote = (CBasedNote.E.toRaw() + key.toRaw()) % 12
    let type = ChordType.Minor7
    let chordScales = [
      noteArray([.E, .F, .G, .A, .B, .C, .D], key: key),
      noteArray([.E, .F, .G, .A, .Bb, .B, .C, .D], key: key)
    ]
    let chord = noteArray([.E, .G, .B, .D], key: key)
    let important = [0, 2, 4, 6]
    return ChordData(baseNote: bassNote, type: type, chordScale: chordScales, importantScaleIndexes: important, chordNotes: chord, root: bassNote)
  }
  
  class func IVChord(#key: CBasedNote) -> ChordData {
    let bassNote = (CBasedNote.F.toRaw() + key.toRaw()) % 12
    let type = ChordType.Major7
    let chordScales = [
      noteArray([.F, .G, .A, .B, .C, .D, .E], key: key),
      noteArray([.F, .G, .Ab, .A, .B, .C, .D, .E], key: key)
    ]
    let chord = noteArray([.F, .A, .C, .E], key: key)
    let important = [0, 2, 4, 6]
    return ChordData(baseNote: bassNote, type: type, chordScale: chordScales, importantScaleIndexes: important, chordNotes: chord, root: bassNote)
  }
  
  class func ivChord(#key: CBasedNote) -> ChordData {
    let bassNote = (CBasedNote.F.toRaw() + key.toRaw()) % 12
    let type = ChordType.Major7
    let chordScales = [
      noteArray([.F, .G, .Ab, .Bb, .C, .D, .E], key: key),
      noteArray([.F, .G, .Ab, .Bb, .B, .C, .D, .E], key: key)
    ]
    let chord = noteArray([.F, .A, .C, .E], key: key)
    let important = [0, 2, 4, 6]
    return ChordData(baseNote: bassNote, type: type, chordScale: chordScales, importantScaleIndexes: important, chordNotes: chord, root: bassNote)
  }
  
  class func viChord(#key: CBasedNote) -> ChordData {
    let bassNote = (CBasedNote.A.toRaw() + key.toRaw()) % 12
    let type = ChordType.Minor7
    let chordScales = [
      noteArray([.A, .B, .C, .D, .E, .F, .G], key: key),
      noteArray([.A, .B, .C, .D, .Eb, .E, .F, .G], key: key),
    ]
    let chord = noteArray([.A, .C, .E, .G], key: key)
    let important = [0, 2, 4, 6]
    return ChordData(baseNote: bassNote, type: type, chordScale: chordScales, importantScaleIndexes: important, chordNotes: chord, root: bassNote)
  }
  
  class func viiChord(#key: CBasedNote) -> ChordData {
    let bassNote = (CBasedNote.B.toRaw() + key.toRaw()) % 12
    let type = ChordType.DimPartial
    let chordScales = [
      noteArray([.B, .C, .D, .E, .F, .G, .A], key: key),
      noteArray([.B, .Db, .D, .E, .F, .G, .Gb], key: key)
    ]
    let chord = noteArray([.B, .D, .F, .A], key: key)
    let important = [0, 2, 4, 6]
    return ChordData(baseNote: bassNote, type: type, chordScale: chordScales, importantScaleIndexes: important, chordNotes: chord, root: bassNote)
  }
  
  /*
  Major ii-V-I chords
  
  key: Represents which key these chords should be in. Should be the same for the ii, V, I chords you are calling.
  */
  
  class func IChordMajor9(#key: CBasedNote) -> ChordData {
    let bassNote = (CBasedNote.C.toRaw() + key.toRaw()) % 12
    let type = ChordType.Major7
    let chordScales = [
      noteArray([.C, .D, .E, .F, .G, .A, .B], key: key),
      noteArray([.C, .D, .Eb, .E, .F, .G, .A, .B ], key: key)
    ]
    let chord = noteArray([.E, .G, .B, .D], key: key)
    let important = [0, 2, 4, 6]
    return ChordData(baseNote: bassNote, type: type, chordScale: chordScales, importantScaleIndexes: important, chordNotes: chord, root: bassNote)
  }
  
  class func iiChordMajorABForm(#key: CBasedNote) -> ChordData {
    let bassNote = (CBasedNote.D.toRaw() + key.toRaw()) % 12
    let type = ChordType.Minor7
    let chordScales = [
      noteArray([.D, .E, .F, .G, .A, .B, .C], key: key),
      noteArray([.D, .E, .F, .G, .Ab, .A, .B, .C], key: key)
    ]
    let chord = noteArray([.F, .A, .C, .E], key: key)
    let important = [0, 2, 4, 6]
    return ChordData(baseNote: bassNote, type: type, chordScale: chordScales, importantScaleIndexes: important, chordNotes: chord, root: bassNote)
  }
  
  class func VChordMajorABForm(#key: CBasedNote) -> ChordData {
    let bassNote = (CBasedNote.G.toRaw() + key.toRaw()) % 12
    let type = ChordType.Dom7
    // Mixolydian scale and a whole tone scale
    let chordScales = [
      noteArray([.G, .A, .B, .C, .D, .E, .F], key: key),
      noteArray([.G, .A, .Ab, .B, .C, .D, .E, .F], key: key),
      noteArray([.G, .A, .B, .Db, .Eb, .F], key: key)
    ]
    let chord = noteArray([.B, .E, .F, .A], key: key)
    let important = [0, 2, 4, 6]
    return ChordData(baseNote: bassNote, type: type, chordScale: chordScales, importantScaleIndexes: important, chordNotes: chord, root: bassNote)
  }
  
  /*
  Minor ii-V-i chords
  */
  class func iChordMinor9(#key: CBasedNote) -> ChordData {
    let bassNote = (CBasedNote.C.toRaw() + key.toRaw()) % 12
    let type = ChordType.Minor7
    let chordScales = [
      noteArray([.C, .D, .Eb, .F, .G, .Ab, .Bb], key: key),
      noteArray([.C, .D, .Eb, .F, .Gb, .G, .Ab, .Bb], key: key)
    ]
    let chord = noteArray([.Eb, .G, .Bb, .D], key: key)
    let important = [0, 2, 4, 6]
    let root = bassNote
    return ChordData(baseNote: bassNote, type: type, chordScale: chordScales, importantScaleIndexes: important, chordNotes: chord, root: root)
  }
  
  class func iiChordMinorABForm(#key: CBasedNote) -> ChordData {
    let bassNote = (CBasedNote.D.toRaw() + key.toRaw()) % 12
    let type = ChordType.DimPartial
    let chordScales = [
      noteArray([.D, .Eb, .F, .G, .Ab, .Bb, .C], key: key),
      noteArray([.D, .E, .F, .G, .Ab, .Bb, .B, .Db], key: key)
    ]
    let chord = noteArray([.F, .Ab, .C, .D], key: key)
    let important = [0, 2, 4, 6]
    let root = bassNote
    return ChordData(baseNote: bassNote, type: type, chordScale: chordScales, importantScaleIndexes: important, chordNotes: chord, root: root)
  }
  
  class func VChordMinorABForm(#key: CBasedNote) -> ChordData {
    let bassNote = (CBasedNote.G.toRaw() + key.toRaw()) % 12
    let type = ChordType.Dom7
    let chordScales = [
      noteArray([.G, .Ab, .B, .C, .D, .Eb, .F], key: key),
      noteArray([.G, .A, .B, .Db, .Eb, .F], key: key)
    ]
    let chord = noteArray([.B, .Eb, .F, .Ab], key: key)
    let important = [0, 2, 4, 6]
    let root = bassNote
    return ChordData(baseNote: bassNote, type: type, chordScale: chordScales, importantScaleIndexes: important, chordNotes: chord, root: root)
  }
  
  /*
  Inversions
  */
  
  class func i9OverV(#key: CBasedNote) -> ChordData {
    let bassNote = (CBasedNote.C.toRaw() + key.toRaw()) % 12
    let type = ChordType.Minor7
    let chordScales = [
    noteArray([.C, .D, .Eb, .F, .G, .Ab, .Bb], key: key),
    noteArray([.C, .D, .Eb, .F, .Gb, .G, .Ab, .Bb], key: key)
    ]
    let chord = noteArray([.Eb, .G, .Bb, .D], key: key)
    let important = [0, 2, 4, 6]
    let root = (CBasedNote.G.toRaw() + key.toRaw()) % 12
    return ChordData(baseNote: bassNote, type: type, chordScale: chordScales, importantScaleIndexes: important, chordNotes: chord, root: root)
  }
  
  class func I9OverV(#key: CBasedNote) -> ChordData {
    let bassNote = (CBasedNote.C.toRaw() + key.toRaw()) % 12
    let type = ChordType.Major7
    let chordScales = [
      noteArray([.C, .D, .E, .F, .G, .A, .B], key: key),
      noteArray([.C, .D, .Eb, .E, .F, .G, .A, .B], key: key)
    ]
    let chord = noteArray([.E, .G, .B, .D], key: key)
    let important = [0, 2, 4, 6]
    let root = (CBasedNote.G.toRaw() + key.toRaw()) % 12
    return ChordData(baseNote: bassNote, type: type, chordScale: chordScales, importantScaleIndexes: important, chordNotes: chord, root: root)
  }
  
  class func iOverVII(#key: CBasedNote) -> ChordData {
    let bassNote = (CBasedNote.C.toRaw() + key.toRaw()) % 12
    let type = ChordType.Minor7
    let chordScales = [
      noteArray([.C, .D, .Eb, .F, .G, .Ab, .Bb], key: key),
      noteArray([.C, .D, .Eb, .F, .Gb, .G, .Ab, .Bb], key: key)
    ]
    let chord = noteArray([.C, .Eb, .G, .Bb], key: key)
    let important = [0, 2, 4, 6]
    let root = (CBasedNote.Bb.toRaw() + key.toRaw()) % 12
    return ChordData(baseNote: bassNote, type: type, chordScale: chordScales, importantScaleIndexes: important, chordNotes: chord, root: root)
  }
  
  /*
  Minor based chords
  */
  class func flatVISharp11(#key: CBasedNote) -> ChordData {
    let bassNote = (CBasedNote.Ab.toRaw() + key.toRaw()) % 12
    let type = ChordType.Dom7
    let chordScales = [
      noteArray([.Ab, .Bb, .C, .D, .Eb, .F, .Gb], key: key)
    ]
    let chord = noteArray([.Ab, .C, .Eb, .Gb], key: key)
    let important = [0, 2, 4, 6]
    let root = (CBasedNote.Ab.toRaw() + key.toRaw()) % 12
    return ChordData(baseNote: bassNote, type: type, chordScale: chordScales, importantScaleIndexes: important, chordNotes: chord, root: root)
  }
  
  /*
  Diminished Ascending Chords
  */
  class func sharpiDimChord(#key: CBasedNote) -> ChordData {
    let bassNote = (CBasedNote.Db.toRaw() + key.toRaw()) % 12
    let type = ChordType.DimFully
    let chordScales = [
      noteArray([.Db, .D, .E, .F, .G, .A, .Bb], key: key),
      noteArray([.Db, .Eb, .E, .Gb, .G, .A, .Bb, .C], key: key)
    ]
    let chord = noteArray([.Db, .E, .G, .Bb], key: key)
    let important = [0, 2, 4, 6]
    return ChordData(baseNote: bassNote, type: type, chordScale: chordScales, importantScaleIndexes: important, chordNotes: chord, root: bassNote)
  }
  
  class func sharpiiDimChord(#key: CBasedNote) -> ChordData {
    let bassNote = (CBasedNote.Eb.toRaw() + key.toRaw()) % 12
    let type = ChordType.DimFully
    let chordScales = [
      noteArray([.Eb, .E, .Gb, .G, .A, .B, .C], key: key),
      noteArray([.Eb, .F, .Gb, .Ab, .A, .B, .C, .Db], key: key)
    ]
    let chord = noteArray([.Eb, .Gb, .A, .C], key: key)
    let important = [0, 2, 4, 6]
    return ChordData(baseNote: bassNote, type: type, chordScale: chordScales, importantScaleIndexes: important, chordNotes: chord, root: bassNote)
  }
  
  // Helpers
  
  enum CBasedNote: Int {
    case C = 0
    case Db
    case D
    case Eb
    case E
    case F
    case Gb
    case G
    case Ab
    case A
    case Bb
    case B
  }
  
  // Returns an always ascending sequence of notes
  class func noteArray(notes: [CBasedNote], key: CBasedNote) -> [Int] {
    
    let transpose = key.toRaw()
    
    let intNotes: [Int] = notes.map {
      note in
      return (note.toRaw() + transpose) % 12
    }
    
    var octave: Int = 0
    var previousNote: Int = -1
    return intNotes.map {
      note in
      if (note < previousNote) {
        octave++
      }
      previousNote = note
      return note + octave * 12
    }
  }
}


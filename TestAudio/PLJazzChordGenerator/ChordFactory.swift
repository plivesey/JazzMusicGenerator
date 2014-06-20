//
//  ChordFactory.swift
//  TestAudio
//
//  Created by Peter Livesey on 6/18/14.
//  Copyright (c) 2014 Peter Livesey. All rights reserved.
//

import Foundation

/*
Major ii-V-I chords
*/

func IChordMajor(#transposition: Int8) -> ChordData {
  let bassNote = CBasedNote.C.toRaw() + transposition
  let type = ChordType.Major7
  let chordScales = [
    noteArray([.C, .D, .E, .F, .G, .A, .B], transposition)
  ]
  let chord = noteArray([.C, .E, .G, .B], transposition)
  let important = [0, 2, 4, 6]
  let root = bassNote
  return ChordData(baseNote: bassNote, type: type, chordScale: chordScales, importantScaleIndexes: important, chordNotes: chord, root: root)
}

func iiChordMajorABForm(#transposition: Int8) -> ChordData {
  let bassNote = CBasedNote.D.toRaw() + transposition
  let type = ChordType.Minor7
  let chordScales = [
    noteArray([.D, .E, .F, .G, .A, .B, .C], transposition)
  ]
  let chord = noteArray([.F, .A, .C, .E], transposition)
  let important = [0, 2, 4, 6]
  let root = bassNote
  return ChordData(baseNote: bassNote, type: type, chordScale: chordScales, importantScaleIndexes: important, chordNotes: chord, root: root)
}

func VChordMajorABForm(#transposition: Int8) -> ChordData {
  let bassNote = CBasedNote.G.toRaw() + transposition
  let type = ChordType.Dom7
  let chordScales = [
    noteArray([.G, .A, .B, .C, .D, .E, .F], transposition),
    noteArray([.G, .A, .B, .Db, .Eb, .F], transposition)
    ]
  let chord = noteArray([.A, .B, .E, .F], transposition)
  let important = [0, 2, 4, 6]
  let root = bassNote
  return ChordData(baseNote: bassNote, type: type, chordScale: chordScales, importantScaleIndexes: important, chordNotes: chord, root: root)
}

/*
 Minor ii-V-i chords
*/
func iChordMinor(#transposition: Int8) -> ChordData {
  let bassNote = CBasedNote.C.toRaw() + transposition
  let type = ChordType.Minor7
  let chordScales = [
    noteArray([.C, .D, .Eb, .F, .G, .Ab, .Bb], transposition)
  ]
  let chord = noteArray([.C, .Eb, .G, .Bb], transposition)
  let important = [0, 2, 4, 6]
  let root = bassNote
  return ChordData(baseNote: bassNote, type: type, chordScale: chordScales, importantScaleIndexes: important, chordNotes: chord, root: root)
}

func iiChordMinorABForm(#transposition: Int8) -> ChordData {
  let bassNote = CBasedNote.D.toRaw() + transposition
  let type = ChordType.DimPartial
  let chordScales = [
    noteArray([.D, .Eb, .F, .G, .Ab, .Bb, .C], transposition),
    noteArray([.D, .E, .F, .G, .Ab, .Bb, .B, .Db], transposition)
  ]
  let chord = noteArray([.F, .Ab, .C, .D], transposition)
  let important = [0, 2, 4, 6]
  let root = bassNote
  return ChordData(baseNote: bassNote, type: type, chordScale: chordScales, importantScaleIndexes: important, chordNotes: chord, root: root)
}

func VChordMinorABForm(#transposition: Int8) -> ChordData {
  let bassNote = CBasedNote.G.toRaw() + transposition
  let type = ChordType.Dom7
  let chordScales = [
    noteArray([.G, .Ab, .B, .C, .D, .Eb, .F], transposition),
    noteArray([.G, .A, .B, .Db, .Eb, .F], transposition)
  ]
  let chord = noteArray([.Ab, .B, .Eb, .F], transposition)
  let important = [0, 2, 4, 6]
  let root = bassNote
  return ChordData(baseNote: bassNote, type: type, chordScale: chordScales, importantScaleIndexes: important, chordNotes: chord, root: root)
}

// Helpers

enum CBasedNote: Int8 {
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
func noteArray(notes: CBasedNote[], transposition: Int8) -> Int8[] {
  var octave: Int8 = 0
  var previousNote: Int8 = -1
  return notes.map {
    note in
    if (note.toRaw() < previousNote) {
      octave++
    }
    return note.toRaw() + octave * 12 + transposition
  }
}

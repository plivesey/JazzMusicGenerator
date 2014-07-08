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

key: Represents which key these chords should be in. Should be the same for the ii, V, I chords you are calling.
*/

func IChordMajor(#key: CBasedNote) -> ChordData {
  let bassNote = (CBasedNote.C.toRaw() + key.toRaw()) % 12
  let type = ChordType.Major7
  let chordScales = [
    noteArray([.C, .D, .E, .F, .G, .A, .B], key: key),
    noteArray([.C, .D, .Eb, .E, .G, .A], key: key)
  ]
  let chord = noteArray([.C, .E, .G, .B], key: key)
  let important = [0, 2, 4, 6]
  return ChordData(baseNote: bassNote, type: type, chordScale: chordScales, importantScaleIndexes: important, chordNotes: chord, root: bassNote)
}

func iiChordMajorABForm(#key: CBasedNote) -> ChordData {
  let bassNote = (CBasedNote.D.toRaw() + key.toRaw()) % 12
  let type = ChordType.Minor7
  let chordScales = [
    noteArray([.D, .E, .F, .G, .A, .B, .C], key: key),
    noteArray([.D, .F, .G, .Ab, .A, .C], key: key)
  ]
  let chord = noteArray([.F, .A, .C, .E], key: key)
  let important = [0, 2, 4, 6]
  return ChordData(baseNote: bassNote, type: type, chordScale: chordScales, importantScaleIndexes: important, chordNotes: chord, root: bassNote)
}

func VChordMajorABForm(#key: CBasedNote) -> ChordData {
  let bassNote = (CBasedNote.G.toRaw() + key.toRaw()) % 12
  let type = ChordType.Dom7
  // Mixolydian scale and a whole tone scale
  let chordScales = [
    noteArray([.G, .A, .B, .C, .D, .E, .F], key: key),
    noteArray([.G, .A, .Ab, .B, .D, .E], key: key),
    noteArray([.G, .A, .B, .Db, .Eb, .F], key: key)
  ]
  let chord = noteArray([.B, .E, .F, .A], key: key)
  let important = [0, 2, 4, 6]
  return ChordData(baseNote: bassNote, type: type, chordScale: chordScales, importantScaleIndexes: important, chordNotes: chord, root: bassNote)
}

/*
 Minor ii-V-i chords
*/
func iChordMinor(#key: CBasedNote) -> ChordData {
  let bassNote = (CBasedNote.C.toRaw() + key.toRaw()) % 12
  let type = ChordType.Minor7
  let chordScales = [
    noteArray([.C, .D, .Eb, .F, .G, .Ab, .Bb], key: key),
    noteArray([.C, .Eb, .F, .Gb, .G, .Bb], key: key)
  ]
  let chord = noteArray([.C, .Eb, .G, .Bb], key: key)
  let important = [0, 2, 4, 6]
  let root = bassNote
  return ChordData(baseNote: bassNote, type: type, chordScale: chordScales, importantScaleIndexes: important, chordNotes: chord, root: root)
}

func iiChordMinorABForm(#key: CBasedNote) -> ChordData {
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

func VChordMinorABForm(#key: CBasedNote) -> ChordData {
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
func noteArray(notes: CBasedNote[], #key: CBasedNote) -> Int8[] {
  
  let transpose = key.toRaw()
  
  let intNotes: Int8[] = notes.map {
    note in
    return (note.toRaw() + transpose) % 12
  }
  
  var octave: Int8 = 0
  var previousNote: Int8 = -1
  return intNotes.map {
    note in
    if (note < previousNote) {
      octave++
    }
    previousNote = note
    return note + octave * 12
  }
}

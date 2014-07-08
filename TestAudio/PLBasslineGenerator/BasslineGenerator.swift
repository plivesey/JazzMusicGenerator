//
//  BasslineGenerator.swift
//  TestAudio
//
//  Created by Peter Livesey on 6/30/14.
//  Copyright (c) 2014 Peter Livesey. All rights reserved.
//

import Foundation

class BasslineGenerator {
  
  class func generateBasslineForChordMeasures(chordMeasures: ChordMeasure[]) -> MelodyMeasure[] {
    var measures = MelodyMeasure[]()
    
    // Initialize
    // Should be a constant for 36
    var currentNote = chordMeasures[0].chords[0].chord.root + 36
    
    for (measureIndex, measure) in enumerate(chordMeasures) {
      var notes = MelodyNote[]()
      for (chordIndex, chord) in enumerate(measure.chords) {
        let nextChordOp = MusicUtil.findNextChordInMeaures(chordMeasures, measureIndex: measureIndex, chordIndex: chordIndex)
        if let nextChord = nextChordOp {
          let destinationNote = destinationNoteForChord(currentNote: currentNote, destinationChord: nextChord)
          let nextNotes = generateBassNotesFromCurrentNote(currentNote, destination: destinationNote, chordScale: chord.chord.mainChordScale, beats: chord.beats)
          notes.extend(nextNotes)
          currentNote = destinationNote
        } else {
          notes.append((currentNote, chord.beats))
        }
      }
      measures.append(MelodyMeasure(notes: notes))
    }
    return measures
  }
  
  class func generateBassNotesFromCurrentNote(var currentNote: Int8, destination: Int8, chordScale: Int8[], beats: Float) -> MelodyNote[] {
    var notes = MelodyNote[]()
    
    let scaleAbove = noteAbove(destination, scale: chordScale)
    let scaleBelow = noteBelow(destination, scale: chordScale)
    let appNotes = approachNotes(destination, scaleAbove: scaleAbove, scaleBelow: scaleBelow)
    let newDestination = appNotes.randomElement().note
    
    for _ in 0..beats-1 {
      notes.append((currentNote, 1))
      let newNote = JazzMelodyGenerator.stepNote(currentNote, destinationNote: newDestination, chordScale: chordScale)
      currentNote = newNote
    }
    
    notes.append((newDestination, 1))
    
    return notes
  }
  
  class func destinationNoteForChord(#currentNote: Int8, destinationChord: ChordData) -> Int8 {
    var highNote = destinationChord.root
    while highNote < currentNote {
      highNote += 12
    }
    let lowNote = highNote - 12
    // TODO: Should be a constant
    if lowNote < 36 {
      return highNote
    }
    // TODO: Should be a constant
    if highNote > 53 {
      return lowNote
    }
    if currentNote - lowNote > highNote - currentNote {
      return highNote
    } else {
      return lowNote
    }
  }
}
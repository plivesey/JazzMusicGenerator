//
//  BasslineGenerator.swift
//  TestAudio
//
//  Created by Peter Livesey on 6/30/14.
//  Copyright (c) 2014 Peter Livesey. All rights reserved.
//

import Foundation

class BasslineGenerator {
  
  class func generateBasslineForChordMeasures(chordMeasures: [ChordMeasure]) -> [ChordNoteMeasure] {
    var measures = [ChordNoteMeasure]()
    
    // Initialize
    // Should be a constant for 36
    var currentNote = chordMeasures[0].chords[0].chord.root + 36
    
    for (measureIndex, measure) in enumerate(chordMeasures) {
      var notes = [ChordNote]()
      for (chordIndex, chord) in enumerate(measure.chords) {
        let nextChordOp = MusicUtil.findNextChordInMeaures(chordMeasures, measureIndex: measureIndex, chordIndex: chordIndex)
        if let nextChord = nextChordOp {
          let destinationNote = destinationNoteForChord(currentNote: currentNote, destinationChord: nextChord)
          
          var chordScale = chord.chord.mainChordScale
          if abs(currentNote - destinationNote) > 5 {
            // If we need to make a 'large' jump, let's use the chord's notes instead of stepped notes
            chordScale = chord.chord.importantScaleIndexes.map {
              index in
              return chord.chord.mainChordScale[index]
            }
          }
          
          let nextNotes = generateBassNotesFromCurrentNote(currentNote, destination: destinationNote, chordScale: chord.chord.mainChordScale, beats: chord.beats)
          notes.extend(nextNotes)
          currentNote = destinationNote
        } else {
          notes.append(ChordNote(notes: [currentNote], beats: chord.beats))
        }
      }
      measures.append(ChordNoteMeasure(notes: notes))
    }
    return measures
  }
  
  class func generateBassNotesFromCurrentNote(var currentNote: Int, destination: Int, chordScale: [Int], beats: Float) -> [ChordNote] {
    var notes = [ChordNote]()
    
    let scaleAbove = noteAbove(destination, scale: chordScale)
    let scaleBelow = noteBelow(destination, scale: chordScale)
    let appNotes = approachNotes(destination, scaleAbove: scaleAbove, scaleBelow: scaleBelow)
    let newDestination = appNotes.randomElement().note
    
    for _ in 0..<Int(beats-1) {
      notes.append(ChordNote(note: currentNote, beats: 1))
      let newNote = JazzMelodyGenerator.stepNote(currentNote, destinationNote: newDestination, chordScale: chordScale)
      currentNote = newNote
    }
    
    notes.append(ChordNote(notes: [newDestination], beats: 1))
    
    return notes
  }
  
  class func destinationNoteForChord(#currentNote: Int, destinationChord: ChordData) -> Int {
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
    if highNote > 55 {
      return lowNote
    }
    if currentNote - lowNote > highNote - currentNote {
      return highNote
    } else {
      return lowNote
    }
  }
}

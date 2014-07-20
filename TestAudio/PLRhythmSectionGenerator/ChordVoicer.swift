//
//  ChordVoicer.swift
//  TestAudio
//
//  Created by Peter Livesey on 7/13/14.
//  Copyright (c) 2014 Peter Livesey. All rights reserved.
//

import Foundation

class ChordVoicer {
  
  class func voicedChordFromChordNote(chordNote: ChordNote, closeTo: Int, min: Int, max: Int) -> ChordNote {
    if chordNote.notes.count == 0 {
      // No voicing needed
      return chordNote
    }
    
    // Find the bass note which is closer. Build up from there.
    // If out of bounds, step in the direction until you get there
    let zeroBasedNotes = MusicUtil.zeroBasedScale(chordNote.notes)
    var bassNote = MusicUtil.closestNoteToNote(closeTo, fromScale: zeroBasedNotes)
    // TODO: Implement min/max
    
    //TODO: Clean up this code
    var otherOrderedNotes: [Int] = [ ]
    var scaleIndex = bassNote.scaleIndex + 1
    while scaleIndex != bassNote.scaleIndex {
      if scaleIndex >= zeroBasedNotes.count {
        scaleIndex = 0
      }
      otherOrderedNotes.append(zeroBasedNotes[scaleIndex])
      if scaleIndex == bassNote.scaleIndex {
        break;
      }
      scaleIndex++
    }
    
    var notes = [ bassNote.note ]
    for note in otherOrderedNotes {
      var varNote = note
      while varNote < notes[notes.count - 1] {
        varNote += 12
      }
      notes.append(varNote)
    }
    
    return ChordNote(notes: notes, beats: chordNote.beats)
  }
}

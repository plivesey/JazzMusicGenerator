//
//  MusicUtil+NotePicker.swift
//  TestAudio
//
//  Created by Peter Livesey on 7/7/14.
//  Copyright (c) 2014 Peter Livesey. All rights reserved.
//

import Foundation

extension MusicUtil {
  
  class func notesToDestination(destination: Int8, fromStart start: Int8, numberOfNotes: Int, chordScale: Int8[]) -> Int8[] {
    assert(numberOfNotes > 0)
    
    let notesBetween = scaleNotesBetween(start: start, destination: destination, chordScale: chordScale)
    // cases
    /*
    no notes between - play above/below destination
    notes between is perfect number - return all the notes
    notes between is too many - play all the notes then end on above/below
    notes between arn't enough - skip over some of the notes
    */
    var notes = Int8[]()
    if notesBetween.count + 1 <= numberOfNotes {
      notes.append(start)
      notes.extend(notesBetween)
      
      // Will be at least 1 big
      var currentNote = notes[notes.count - 1]
      
      while notes.count < numberOfNotes {
        currentNote = stepNote(currentNote, destinationNote: destination, chordScale: chordScale)
        notes.append(currentNote)
      }
    } else {
      // Too many notes
      notes.append(start)
      // Will always be > 0
      let notesLeft = numberOfNotes - 1
      // Example: 5 notes, we want 2. Index jump is 2. So use index 0 + .5 * jump and 0 + 1.5 * jump
      let indexJump = Float(notesBetween.count) / Float(notesLeft)
      for i in 0..notesLeft {
        let indexFloat = (Float(i) + 0.5) * indexJump
        var index = Int(indexFloat)
        if index >= notesBetween.count {
          index = notesBetween.count - 1
        }
        let note = notesBetween[index]
        notes.append(note)
      }
    }
    
    println("PICKING: S: \(start) D:\(destination) N:\(numberOfNotes)")
    println(chordScale)
    println(notesBetween)
    println(notes)
    
    return notes
  }
  
  class func scaleNotesBetween(#start: Int8, destination: Int8, chordScale: Int8[]) -> Int8[] {
    if start == destination {
      return []
    }
    var notes = Int8[]()
    var currentNote = start
    if start < destination {
      // Need to go up
      currentNote = noteAbove(currentNote, scale: chordScale)
      while currentNote < destination {
        notes.append(currentNote)
        currentNote = noteAbove(currentNote, scale: chordScale)
      }
    } else {
      // Need to go down
      currentNote = noteBelow(currentNote, scale: chordScale)
      while currentNote > destination {
        notes.append(currentNote)
        currentNote = noteBelow(currentNote, scale: chordScale)
      }
    }
    return notes
  }
  
  // Steps towards the destination without playing it
  class func stepNote(var currentNote: Int8, destinationNote: Int8, chordScale: Int8[]) -> Int8 {
    let upwardDirection = currentNote < destinationNote
    do {
      if (upwardDirection) {
        currentNote = noteAbove(currentNote, scale: chordScale)
      } else {
        currentNote = noteBelow(currentNote, scale: chordScale)
      }
    } while (currentNote == destinationNote)
    return currentNote
  }
}

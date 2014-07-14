//
//  MusicUtil+NotePicker.swift
//  TestAudio
//
//  Created by Peter Livesey on 7/7/14.
//  Copyright (c) 2014 Peter Livesey. All rights reserved.
//

import Foundation

extension MusicUtil {
  
  /*
  Returns an array of notes to get to a destination. It never plays the destination note.
  */
  class func notesToDestination(destination: Int8, fromStart start: Int8, numberOfNotes: Int, chordScale: [Int8]) -> [Int8] {
    assert(numberOfNotes > 0)
    
    let notesBetween = scaleNotesBetween(start: start, destination: destination, chordScale: chordScale)
    // cases
    /*
    no notes between - play above/below destination
    notes between is perfect number - return all the notes
    notes between is too many - play all the notes then end on above/below
    notes between arn't enough - skip over some of the notes
    */
    var notes = [Int8]()
    if notesBetween.count + 1 <= numberOfNotes {
      notes.append(start)
      notes.extend(notesBetween)
      
      // Will be at least 1 big
      var currentNote = notes[notes.count - 1]
      
      var upwardDirection = currentNote < destination
      while notes.count < numberOfNotes {
        let newUpwardDirection = currentNote < destination
        // We want to change direction if we've overshot
        // BUT, we don't want to keep changing back and forth.
        // So, if we've already overshot, but have plent of notes left, let's keep going
        if upwardDirection != newUpwardDirection {
          // Consider changing
          let numberOfNotesBetween = scaleNotesBetween(start: currentNote, destination: destination, chordScale: chordScale).count
          let numberNotesRemaining = numberOfNotes - notes.count
          if numberNotesRemaining < numberOfNotesBetween + 2 {
            // We need to play the next note, then back to this note, then all the notes between to get to the destination
            // If we don't have at least that many notes remaining, then let's change direction now
            upwardDirection = newUpwardDirection
          }
        }
        // Go to the next note based on direction
        do {
          if (upwardDirection) {
            currentNote = noteAbove(currentNote, scale: chordScale)
          } else {
            currentNote = noteBelow(currentNote, scale: chordScale)
          }
        } while (currentNote == destination)
        
        notes.append(currentNote)
      }
    } else {
      // Too many notes
      notes.append(start)
      // Will always be > 0
      let notesLeft = numberOfNotes - 1
      // Example: 5 notes, we want 2. Index jump is 2. So use index 0 + .5 * jump and 0 + 1.5 * jump
      let indexJump = Float(notesBetween.count) / Float(notesLeft)
      for i in 0..<notesLeft {
        let indexFloat = (Float(i) + 0.5) * indexJump
        var index = Int(indexFloat)
        if index >= notesBetween.count {
          index = notesBetween.count - 1
        }
        let note = notesBetween[index]
        notes.append(note)
      }
    }
    
    return notes
  }
  
  /*
    Picks the closest note in a scale to that note. Could return the same note.
    If there is a tie, picks a random note to return
  */
  class func closestNoteToNote(note: Int8, fromScale scale: [Int8]) -> (note: Int8, scaleIndex: Int) {
    var minDistance: Int8 = 13
    var closestNotesIndex: [Int] = []
    for (index, scaleNote) in enumerate(scale) {
      let distance = noteDistance(scaleNote, note)
      if distance == minDistance {
        closestNotesIndex.append(index)
      } else if distance < minDistance {
        closestNotesIndex = [index]
        minDistance = distance
      }
    }
    
    let zeroBasedNoteIndex = closestNotesIndex.randomElement()
    return (noteFromScale(scale[zeroBasedNoteIndex], closestToNote: note), zeroBasedNoteIndex)
  }
  
  // Returns the note distance assuming both are as close as could be
  // As in, distance between 0 and 1 + 12*5 is 1
  class func noteDistance(note: Int8, _ otherNote: Int8) -> Int8 {
    let baseNote = note % 12
    let baseOtherNote = otherNote % 12
    let difference = abs(baseNote - baseOtherNote)
    // If the difference is above 6, then return 12 - difference since it'll be less. Max distance of two notes is 6
    return difference < 6 ? difference : 12 - difference
  }
  
  class func noteFromScale(var scaleNote: Int8, closestToNote note: Int8) -> Int8 {
    assert(note >= 12)
    assert(scaleNote < 12)
    
    while abs(scaleNote + 12 - note) < abs(scaleNote - note) {
      scaleNote += 12
    }
    return scaleNote
  }
  
  class func scaleNotesBetween(#start: Int8, destination: Int8, chordScale: [Int8]) -> [Int8] {
    if start == destination {
      return []
    }
    var notes = [Int8]()
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
  class func stepNote(var currentNote: Int8, destinationNote: Int8, chordScale: [Int8]) -> Int8 {
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

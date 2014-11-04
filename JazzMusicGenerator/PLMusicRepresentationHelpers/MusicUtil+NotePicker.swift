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
  class func notesToDestination(destination: Int, fromStart start: Int, numberOfNotes: Int, chordScale: [Int]) -> [Int] {
    assert(numberOfNotes > 0)
    
    let notesBetween = scaleNotesBetween(start: start, destination: destination, chordScale: chordScale)
    // cases
    /*
    no notes between - play above/below destination
    notes between is perfect number - return all the notes
    notes between is too many - play all the notes then end on above/below
    notes between arn't enough - skip over some of the notes
    */
    var notes = [Int]()
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
  class func closestNoteToNote(note: Int, fromScale scale: [Int]) -> (note: Int, scaleIndex: Int) {
    var minDistance: Int = 13
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
  class func noteDistance(note: Int, _ otherNote: Int) -> Int {
    let baseNote = note % 12
    let baseOtherNote = otherNote % 12
    let difference = abs(baseNote - baseOtherNote)
    // If the difference is above 6, then return 12 - difference since it'll be less. Max distance of two notes is 6
    return difference < 6 ? difference : 12 - difference
  }
  
  /**
  This function returns a note which has the same letter value as scaleNote, but is as close as possible to another note (which is usually higher than 12).
  */
  class func noteFromScale(var scaleNote: Int, closestToNote note: Int) -> Int {
    assert(scaleNote < 12)
    
    while abs(scaleNote + 12 - note) < abs(scaleNote - note) {
      scaleNote += 12
    }
    return scaleNote
  }
  
  class func scaleNotesBetween(#start: Int, destination: Int, chordScale: [Int]) -> [Int] {
    if start == destination {
      return []
    }
    var notes = [Int]()
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
  class func stepNote(var currentNote: Int, destinationNote: Int, chordScale: [Int]) -> Int {
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
  
  class func noteAbove(note: Int, scale: [Int]) -> Int {
    var zeroedNote = note % 12
    
    // Sort of a hack, revisit later
    if zeroedNote < scale[0] {
      zeroedNote += 12
    }
    
    // Default. use this if noone is higher
    var index = 0
    for i in 0..<scale.count {
      if (scale[i] > zeroedNote) {
        index = i
        // TODO: This line sometimes crashes. Maybe this was just the infinite loop?
        break;
      }
    }
    
    var returnNote = scale[index]
    while (returnNote < note) {
      returnNote += 12
    }
    return returnNote
  }
  
  class func noteBelow(note: Int, scale: [Int]) -> Int {
    var zeroedNote = note % 12
    
    // Sort of a hack, revisit later
    if zeroedNote < scale[0] {
      zeroedNote += 12
    }
    // Default. use this if noone is higher
    var index = scale.count-1
    for i in reverse(0..<scale.count-1) {
      if (scale[i] < zeroedNote) {
        index = i
        break;
      }
    }
    
    var returnNote = scale[index]
    while (returnNote < note-12) {
      returnNote += 12
    }
    return returnNote
  }
  
  class func approachNotes(note: Int, scaleAbove: Int, scaleBelow: Int) -> [ChordNote] {
    let random = RandomHelpers.randomNumberInclusive(0, 3)
    switch(random) {
    case 0:
      // chrom from below
      return [ChordNote(note: note - 1, beats: 1)]
    case 1:
      // chrom from above
      return [ChordNote(note: note + 1, beats: 1)]
    case 2:
      // scale from below
      return [ChordNote(note: scaleBelow, beats: 1)]
    case 3:
      // scale from above
      return [ChordNote(note: scaleAbove, beats: 1)]
    default:
      assert(false)
    }
  }

}

//
//  ScoreCreator.swift
//  TestAudio
//
//  Created by Peter Livesey on 6/19/14.
//  Copyright (c) 2014 Peter Livesey. All rights reserved.
//

import Foundation

// TODO: Move inside
let SONG_TRANSPOSITION: Int = 0

public class ScoreCreator {
  
  public class func instrumentScore(music: [ChordNoteMeasure], _ instrument: PLMusicPlayer.InstrumentType, _ velocity: UInt8) -> (music: [ChordNoteMeasure], instrument: PLMusicPlayer.InstrumentType, velocity: UInt8) {
    return (music, instrument, velocity)
  }
  
  public class func createScore(input: [(music: [ChordNoteMeasure], instrument: PLMusicPlayer.InstrumentType, velocity: UInt8)], secondsPerBeat: Float) -> [PLMusicPlayerNote] {
    
    var music = [PLMusicPlayerNote]()
    
    for instrument in input {
      var notes = notesFromChords(instrument.music, instrument:instrument.instrument, velocity: instrument.velocity, secondsPerBeat: secondsPerBeat)
      
      // Sort of a hack. Making the bass line change in velocity based on it's pitch
      // Not sure where this logic belongs
      if instrument.instrument == .Bass {
        notes = notes.map {
          note in
          return PLMusicPlayerNote(note: note.note,
            instrument: note.instrument,
            velocity: note.velocity - note.note + 48,
            start: note.start,
            duration: note.duration,
            channel: note.channel)
        }

      }
      
      music.extend(notes)
    }
    
    // Sort the notes
    music.sort({
      item, nextItem in
      // This function should return true if the item is before the next item
      return item.start < nextItem.start
    })
    
    return music
  }
  
  class func notesFromChords(melody: [ChordNoteMeasure], instrument: PLMusicPlayer.InstrumentType, velocity: UInt8, secondsPerBeat: Float) -> [PLMusicPlayerNote] {
    var music = [PLMusicPlayerNote]()
    
    for (index, measure) in enumerate(melody) {
      let measureStart = Float(index * 4) * secondsPerBeat
      var start: Float = 0
      for chord in measure.notes {
        let duration = chord.beats
        
        for note in chord.notes {
          let playerNote = PLMusicPlayerNote(note: MusicUtil.UInt8MusicRepresentation(note+SONG_TRANSPOSITION), instrument: instrument, velocity: velocity, start: start+measureStart, duration: duration * secondsPerBeat, channel: 0)
          music.append(playerNote)
        }
        start += duration * secondsPerBeat
      }
    }
    
    return music
  }

}

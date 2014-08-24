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

class ScoreCreator {
  
  class func instrumentScore(music: [ChordNoteMeasure], _ instrument: PLMusicPlayer.InstrumentType, _ velocity: UInt8) -> (music: [ChordNoteMeasure], instrument: PLMusicPlayer.InstrumentType, velocity: UInt8) {
    return (music, instrument, velocity)
  }
  
  class func createScore(input: [(music: [ChordNoteMeasure], instrument: PLMusicPlayer.InstrumentType, velocity: UInt8)], secondsPerBeat: Float) -> [PLMusicPlayerNote] {
    
    var music = [PLMusicPlayerNote]()
    
    for instrument in input {
      music.extend(notesFromChords(instrument.music, instrument:instrument.instrument, velocity: instrument.velocity, secondsPerBeat: secondsPerBeat))
    }
    
    //  music.extend(notesFromMelody(melody, instrument: .Piano, velocity: 80, secondsPerBeat: secondsPerBeat))
    
    //  // Add bassline
    //  var bassLine = notesFromMelody(bassline, instrument: .Bass, velocity: 70, secondsPerBeat: secondsPerBeat)
    //  // TODO: HACK. Make the higher notes quieter
    //  bassLine = bassLine.map {
    //    note in
    //    return PLMusicPlayerNote(note: note.note,
    //      instrument: note.instrument,
    //      velocity: note.velocity - note.note + 40,
    //      start: note.start,
    //      duration: note.duration,
    //      channel: note.channel)
    //  }
    
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

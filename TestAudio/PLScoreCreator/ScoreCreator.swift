//
//  ScoreCreator.swift
//  TestAudio
//
//  Created by Peter Livesey on 6/19/14.
//  Copyright (c) 2014 Peter Livesey. All rights reserved.
//

import Foundation

let SONG_TRANSPOSITION: Int = 0

func createScore(#chords: [ChordNoteMeasure], #melody: [MelodyMeasure], #bassline: [MelodyMeasure], #drums: [ChordNoteMeasure], #secondsPerBeat: Float) -> [PLMusicPlayerNote] {
  var music = [PLMusicPlayerNote]()
  
  // Rhythm section
  music.extend(notesFromChords(chords, instrument: .Piano, velocity: 50, secondsPerBeat: secondsPerBeat))
  
  // Add melody
//  music.extend(notesFromMelody(melody, instrument: .Sax, velocity: 50, secondsPerBeat: secondsPerBeat))
  music.extend(notesFromMelody(melody, instrument: .Piano, velocity: 80, secondsPerBeat: secondsPerBeat))

  // Add bassline
  var bassLine = notesFromMelody(bassline, instrument: .Bass, velocity: 70, secondsPerBeat: secondsPerBeat)
  // TODO: HACK. Make the higher notes quieter
  bassLine = bassLine.map {
    note in
    return PLMusicPlayerNote(note: note.note,
      instrument: note.instrument,
      velocity: note.velocity - note.note + 40,
      start: note.start,
      duration: note.duration,
      channel: note.channel)
  }
  music.extend(bassLine)
  
  // Add drums
  music.extend(notesFromChords(drums, instrument: .Drums, velocity: 70, secondsPerBeat: secondsPerBeat))
  
  // Sort the notes
  music.sort({
    item, nextItem in
    // This function should return true if the item is before the next item
    return item.start < nextItem.start
    })
  
  return music
}

func notesFromChords(melody: [ChordNoteMeasure], #instrument: PLMusicPlayer.InstrumentType, #velocity: UInt8, #secondsPerBeat: Float) -> [PLMusicPlayerNote] {
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

func notesFromMelody(melody: [MelodyMeasure], #instrument: PLMusicPlayer.InstrumentType, #velocity: UInt8, #secondsPerBeat: Float) -> [PLMusicPlayerNote] {
  var music = [PLMusicPlayerNote]()
  
  for (index, measure) in enumerate(melody) {
    let measureStart = Float(index * 4) * secondsPerBeat
    var start: Float = 0
    for note in measure.notes {
      let duration = note.beats
      if note.note != -1 {
        let playerNote = PLMusicPlayerNote(note: MusicUtil.UInt8MusicRepresentation(note.note+SONG_TRANSPOSITION), instrument: instrument, velocity: velocity + UInt8(RandomHelpers.randomNumberInclusive(0, 4)) - 2, start: start+measureStart, duration: duration * secondsPerBeat, channel: 0)
        music.append(playerNote)
      }
      start += duration * secondsPerBeat
    }
  }
  
  return music
}

func createSimpleMusicFromChords(chords: [ChordMeasure], secondsPerBeat: Float) -> [PLMusicPlayerNote] {
  var music = [PLMusicPlayerNote]()
  var start: Float = 0
  for measure in chords {
    for chord in measure.chords {
      let duration = secondsPerBeat * chord.beats
      for note in chord.chord.chordNotes {
        let playerNote = PLMusicPlayerNote(note: MusicUtil.UInt8MusicRepresentation(note), instrument: .Piano, velocity: 98, start: start, duration: duration, channel: 0)
        music.append(playerNote)
      }
      start += duration
    }
  }
  return music
}

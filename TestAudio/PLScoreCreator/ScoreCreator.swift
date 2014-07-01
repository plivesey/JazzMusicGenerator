//
//  ScoreCreator.swift
//  TestAudio
//
//  Created by Peter Livesey on 6/19/14.
//  Copyright (c) 2014 Peter Livesey. All rights reserved.
//

import Foundation

let CHORD_TRANSPOSITION: Int8 = 48
let SONG_TRANSPOSITION: Int8 = 5

func createScore(chords: ChordMeasure[], #melody: MelodyMeasure[], #secondsPerBeat: Float) -> PLMusicPlayerNote[] {
  var music = PLMusicPlayerNote[]()
  var start: Float = 0
  for i in 0..chords.count {
    let chordMeasure = chords[i]
    let melodyMeasure = melody[i]
    
    var chordStart: Float = 0
    var melodyStart: Float = 0
    var chordIndex = 0
    var melodyIndex = 0
    
    while (chordIndex < chordMeasure.chords.count || melodyIndex < melodyMeasure.notes.count) {
      let nextChordStart = chordIndex < chordMeasure.chords.count ? chordStart : 5
      let nextMelodyStart = melodyIndex < melodyMeasure.notes.count ? melodyStart : 5
      if (nextChordStart < nextMelodyStart) {
        // Add next chord
        let duration = chordMeasure.chords[chordIndex].beats * secondsPerBeat
        
        let chord = chordMeasure.chords[chordIndex].chord
        for note in chord.chordNotes {
          let playerNote = PLMusicPlayerNote(note: UInt8(note+CHORD_TRANSPOSITION+SONG_TRANSPOSITION), velocity: 35, start: start+chordStart, duration: duration, channel: 0)
          music.append(playerNote)
        }
        // Bass note
        let playerNote = PLMusicPlayerNote(note: UInt8(chord.baseNote+CHORD_TRANSPOSITION-12+SONG_TRANSPOSITION), velocity: 50, start: start+chordStart, duration: duration, channel: 0)
        music.append(playerNote)
        
        chordIndex++
        chordStart += duration
      } else {
        // Add next melody
        let note = melodyMeasure.notes[melodyIndex]
        let duration = note.beats * secondsPerBeat
        if (note.note != -1) {
          let playerNote = PLMusicPlayerNote(note: UInt8(note.note+SONG_TRANSPOSITION), velocity: 50, start: start+melodyStart, duration: duration, channel: 0)
          music.append(playerNote)
        }
        
        melodyIndex++
        melodyStart += duration
      }
    }
    start += 4 * secondsPerBeat
  }
  return music
}

func createSimpleMusicFromChords(chords: ChordMeasure[], secondsPerBeat: Float) -> PLMusicPlayerNote[] {
  var music = PLMusicPlayerNote[]()
  var start: Float = 0
  for measure in chords {
    for chord in measure.chords {
      let duration = secondsPerBeat * chord.beats
      for note in chord.chord.chordNotes {
        let playerNote = PLMusicPlayerNote(note: UInt8(note), velocity: 98, start: start, duration: duration, channel: 0)
        music.append(playerNote)
      }
      start += duration
    }
  }
  return music
}

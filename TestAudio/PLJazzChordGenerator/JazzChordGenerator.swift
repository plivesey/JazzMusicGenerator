//
//  JazzChordGenerator.swift
//  TestAudio
//
//  Created by Peter Livesey on 6/16/14.
//  Copyright (c) 2014 Peter Livesey. All rights reserved.
//

import Foundation

let scale = [(note:62, major:false), (note:64, major:false), (note:65, major:true), (note:67, major:true), (note:69, major:false)]

func generateRandomChords() -> ChordMeasure[] {
  var nextChord = ChordData(baseNote: 60, type: .Major7, root: 0)
  var chords = ChordMeasure[]()
  while (countElements(chords) < 12) {
    if (countElements(chords) == 8) {
      chords.append(ChordMeasure(chords: [(nextChord, 4)]))
      chords.append(ChordMeasure(chords: [(nextChord, 4)]))
      chords.append(ChordMeasure(chords: [(ChordData(baseNote: 62, type: .Minor7, root: 0), 4)]))
      chords.append(ChordMeasure(chords: [(ChordData(baseNote: 67, type: .Dom7, root: 0), 4)]))
    } else if (countElements(chords) == 10) {
      chords.append(ChordMeasure(chords: [(nextChord, 4)]))
      chords.append(ChordMeasure(chords: [(ChordData(baseNote: 62, type: .Minor7, root: 0), 2), (ChordData(baseNote: 67, type: .Dom7, root: 0), 2)]))
    } else {
      let numberOfMeasures = (arc4random_uniform(2)+1)*2
      let result = generateNextChords(startingChord: nextChord, numberOfMeasures: Int(numberOfMeasures))
      nextChord = result.nextChord.chord
      for chordMeasure in result.chords {
        chords.append(chordMeasure)
      }
    }
  }
  return chords
}

func generateNextChords(#startingChord: ChordData, #numberOfMeasures: Int)
  -> (chords:ChordMeasure[], nextChord: (chord:ChordData, measures:Int)) {
    let x = generateTwoFiveOne(startingChord: startingChord, numberOfMeasures: numberOfMeasures, possibleDestinations: scale)
    return x
}

func generateTwoFiveOne(#startingChord: ChordData, #numberOfMeasures: Int, #possibleDestinations: (note: Int, major: Bool)[])
  -> (chords:ChordMeasure[], nextChord: (chord:ChordData, measures:Int)) {
    var oneNote = possibleDestinations.randomElement()
    while (oneNote.note == startingChord.baseNote) {
      oneNote = possibleDestinations.randomElement()
    }
    if (oneNote.major) {
      // TODO: Sometimes go to 6
      let one = ChordData(baseNote: oneNote.note, type: .Major7, root: 0)
      let two = ChordData(baseNote: oneNote.note + 2, type: .Minor7, root: 0)
      let five = ChordData(baseNote: oneNote.note + 7, type: .Dom7, root: 0)
      if (numberOfMeasures == 2) {
        let measure1 = ChordMeasure(chords: [(startingChord, 4)])
        let measure2 = ChordMeasure(chords: [(two, 2), (five, 2)])
        return ([measure1, measure2], (one, 1))
      } else {
        // Assume 4
        let measure1 = ChordMeasure(chords: [(startingChord, 4)])
        let measure2 = ChordMeasure(chords: [(startingChord, 4)])
        let measure3 = ChordMeasure(chords: [(two, 4)])
        let measure4 = ChordMeasure(chords: [(five, 4)])
        return ([measure1, measure2, measure3, measure4], (one, 2))
      }
    } else {
      // TODO: Sometimes go to other ones
      let one = ChordData(baseNote: oneNote.note, type: .Minor7, root: 0)
      let two = ChordData(baseNote: oneNote.note + 2, type: .DimPartial, root: 0)
      let five = ChordData(baseNote: oneNote.note + 7, type: .Dom7, root: 0)
      if (numberOfMeasures == 2) {
        let measure1 = ChordMeasure(chords: [(startingChord, 4)])
        let measure2 = ChordMeasure(chords: [(two, 2), (five, 2)])
        return ([measure1, measure2], (one, 1))
      } else {
        // Assume 4
        let measure1 = ChordMeasure(chords: [(startingChord, 4)])
        let measure2 = ChordMeasure(chords: [(startingChord, 4)])
        let measure3 = ChordMeasure(chords: [(two, 4)])
        let measure4 = ChordMeasure(chords: [(five, 4)])
        return ([measure1, measure2, measure3, measure4], (one, 2))
      }
    }
}

func createSimpleMusicFromChords(chords: ChordMeasure[], secondsPerBeat: Float) -> PLMusicPlayerNote[] {
  var music = PLMusicPlayerNote[]()
  var start: Float = 0
  for measure in chords {
    for chord in measure.chords {
      let duration = secondsPerBeat * chord.beats
      let notes = chord.chord.chordNotes()
      for note in notes {
        let playerNote = PLMusicPlayerNote(note: UInt8(note), velocity: 98, start: start, duration: duration - 0.1, channel: 0)
        music.append(playerNote)
      }
      start += duration
    }
  }
  return music
}


//
//  JazzChordGenerator.swift
//  TestAudio
//
//  Created by Peter Livesey on 6/16/14.
//  Copyright (c) 2014 Peter Livesey. All rights reserved.
//

import Foundation

let scale: (note: Int8, major: Bool)[] = [(note:62, major:false), (note:64, major:false), (note:65, major:true), (note:67, major:true), (note:69, major:false)]

func generateRandomChords() -> ChordMeasure[] {
  var nextChord = IChordMajor(transposition: 60)
  var chords = ChordMeasure[]()
  while (countElements(chords) < 12) {
    if (countElements(chords) == 8) {
      chords.append(ChordMeasure(chords: [(nextChord, 4)]))
      chords.append(ChordMeasure(chords: [(nextChord, 4)]))
      chords.append(ChordMeasure(chords: [(iiChordMajorABForm(transposition: 60), 4)]))
      chords.append(ChordMeasure(chords: [(VChordMajorABForm(transposition: 60), 4)]))
    } else if (countElements(chords) == 10) {
      chords.append(ChordMeasure(chords: [(nextChord, 4)]))
      chords.append(ChordMeasure(chords: [(iiChordMajorABForm(transposition: 60), 2), (VChordMajorABForm(transposition: 60), 2)]))
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

func generateTwoFiveOne(#startingChord: ChordData, #numberOfMeasures: Int, #possibleDestinations: (note: Int8, major: Bool)[])
  -> (chords:ChordMeasure[], nextChord: (chord:ChordData, measures:Int)) {
    var oneNote = possibleDestinations.randomElement()
    while (oneNote.note == startingChord.baseNote) {
      oneNote = possibleDestinations.randomElement()
    }
    if (oneNote.major) {
      // TODO: Sometimes go to 6
      let one = IChordMajor(transposition: oneNote.note)
      let two = iiChordMajorABForm(transposition: oneNote.note)
      let five = VChordMajorABForm(transposition: oneNote.note)
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
      let one = iChordMinor(transposition: oneNote.note)
      let two = iiChordMinorABForm(transposition: oneNote.note)
      let five = VChordMinorABForm(transposition: oneNote.note)
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
      for note in chord.chord.chordNotes {
        let playerNote = PLMusicPlayerNote(note: UInt8(note-12), velocity: 98, start: start, duration: duration, channel: 0)
        music.append(playerNote)
      }
      start += duration
    }
  }
  return music
}


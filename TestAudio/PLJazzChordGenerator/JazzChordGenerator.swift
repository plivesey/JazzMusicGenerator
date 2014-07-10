//
//  JazzChordGenerator.swift
//  TestAudio
//
//  Created by Peter Livesey on 6/16/14.
//  Copyright (c) 2014 Peter Livesey. All rights reserved.
//

import Foundation

let scale: (note: Int8, major: Bool)[] = [(note:50, major:false), (note:52, major:false), (note:53, major:true), (note:55, major:true), (note:57, major:false)]

func generateRandomChords(#numMeasures: Int) -> ChordMeasure[] {
  var nextChord = IChordMajor(key: .C)
  var chords = ChordMeasure[]()
  while (countElements(chords) < numMeasures) {
    if (countElements(chords) == numMeasures - 4) {
      chords.append(ChordMeasure(chords: [(nextChord, 4)]))
      chords.append(ChordMeasure(chords: [(nextChord, 4)]))
      chords.append(ChordMeasure(chords: [(iiChordMajorABForm(key: .C), 4)]))
      chords.append(ChordMeasure(chords: [(VChordMajorABForm(key: .C), 4)]))
    } else if (countElements(chords) == numMeasures - 2) {
      chords.append(ChordMeasure(chords: [(nextChord, 4)]))
      chords.append(ChordMeasure(chords: [(iiChordMajorABForm(key: .C), 2), (VChordMajorABForm(key: .C), 2)]))
    } else {
      let numberOfMeasures = (arc4random_uniform(2)+1)*2
      let result = generateNextChords(startingChord: nextChord, numberOfMeasures: Int(numberOfMeasures))
      nextChord = result.nextChord
      for chordMeasure in result.chords {
        chords.append(chordMeasure)
      }
    }
  }
  return chords
}

func generateNextChords(#startingChord: ChordData, #numberOfMeasures: Int)
  -> (chords:ChordMeasure[], nextChord: ChordData) {
    return generateTwoFiveOne(startingChord: startingChord, numberOfMeasures: numberOfMeasures, possibleDestinations: scale)
}

func generateTwoFiveOne(#startingChord: ChordData, #numberOfMeasures: Int, #possibleDestinations: (note: Int8, major: Bool)[])
  -> (chords:ChordMeasure[], nextChord: ChordData) {
    var oneNote = possibleDestinations.randomElement()
    while (oneNote.note == startingChord.baseNote) {
      oneNote = possibleDestinations.randomElement()
    }
    
    let key = CBasedNote.fromRaw(oneNote.note % 12)!
    
    if (oneNote.major) {
      // TODO: Sometimes go to 6
      let one = IChordMajor(key: key)
      let two = iiChordMajorABForm(key: key)
      let five = VChordMajorABForm(key: key)
      if (numberOfMeasures == 2) {
        let measure1 = ChordMeasure(chords: [(startingChord, 4)])
        let measure2 = ChordMeasure(chords: [(two, 2), (five, 2)])
        return ([measure1, measure2], one)
      } else {
        // Assume 4
        let measure1 = ChordMeasure(chords: [(startingChord, 4)])
        let measure2 = ChordMeasure(chords: [(startingChord, 4)])
        let measure3 = ChordMeasure(chords: [(two, 4)])
        let measure4 = ChordMeasure(chords: [(five, 4)])
        return ([measure1, measure2, measure3, measure4], one)
      }
    } else {
      // TODO: Sometimes go to other ones
      let one = iChordMinor(key: key)
      let two = iiChordMinorABForm(key: key)
      let five = VChordMinorABForm(key: key)
      if (numberOfMeasures == 2) {
        let measure1 = ChordMeasure(chords: [(startingChord, 4)])
        let measure2 = ChordMeasure(chords: [(two, 2), (five, 2)])
        return ([measure1, measure2], one)
      } else {
        // Assume 4
        let measure1 = ChordMeasure(chords: [(startingChord, 4)])
        let measure2 = ChordMeasure(chords: [(startingChord, 4)])
        let measure3 = ChordMeasure(chords: [(two, 4)])
        let measure4 = ChordMeasure(chords: [(five, 4)])
        return ([measure1, measure2, measure3, measure4], one)
      }
    }
}


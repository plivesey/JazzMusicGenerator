//
//  JazzChordGenerator.swift
//  TestAudio
//
//  Created by Peter Livesey on 6/16/14.
//  Copyright (c) 2014 Peter Livesey. All rights reserved.
//

import Foundation

let scale: (note: Int8, type: ChordType)[] = [
  (0, .Major7),
  (2, .Minor7),
  (4, .Minor7),
  (5, .Major7),
  (7, .Dom7),
  (9, .Minor7),
  (11, .DimPartial)
]

class JazzChordGenerator {
  
  class func generateRandomChords(#numMeasures: Int) -> ChordMeasure[] {
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
  
  class func generateNextChords(#startingChord: ChordData, numberOfMeasures: Int)
    -> (chords:ChordMeasure[], nextChord: ChordData) {
      // Filter out only the chord gens that can handle
      let chordGens = chordGenerators().filter {
        chordGenerator in return chordGenerator.0.canStartOnChord(startingChord, numberOfMeasures: numberOfMeasures)
      }
      let chordGenerator = RandomHelpers.randomElementFromWeightedList(chordGens)
      return chordGenerator.generateNextChords(startingChord: startingChord, numberOfMeasures: numberOfMeasures, scale: scale)
  }
  
  class func chordGenerators() -> (ChordGenProtocol.Type, weight: Int)[] {
    return [
      (TwoFiveOneChordGen.self, weight: 2)
    ]
  }
}



//
//  JazzChordGenerator.swift
//  TestAudio
//
//  Created by Peter Livesey on 6/16/14.
//  Copyright (c) 2014 Peter Livesey. All rights reserved.
//

import Foundation

let scale: [(note: Int8, type: ChordType)] = [
  (0, .Major7),
  (2, .Minor7),
  (4, .Minor7),
  (5, .Major7),
  (7, .Dom7),
  (9, .Minor7),
  (11, .DimPartial)
]

class JazzChordGenerator {
  
  class func generateRandomChords(#numMeasures: Int) -> [ChordMeasure] {
    var nextChord = ChordFactory.IChord(key: .C)
    var chords = [ChordMeasure]()
    while (countElements(chords) < numMeasures) {
      if (countElements(chords) == numMeasures - 4) {
        chords.append(ChordMeasure(chords: [(nextChord, 4)]))
        chords.append(ChordMeasure(chords: [(nextChord, 4)]))
        chords.append(ChordMeasure(chords: [(ChordFactory.iiChordMajorABForm(key: .C), 4)]))
        chords.append(ChordMeasure(chords: [(ChordFactory.VChordMajorABForm(key: .C), 4)]))
      } else if (countElements(chords) == numMeasures - 2) {
        chords.append(ChordMeasure(chords: [(nextChord, 4)]))
        chords.append(ChordMeasure(chords: [(ChordFactory.iiChordMajorABForm(key: .C), 2), (ChordFactory.VChordMajorABForm(key: .C), 2)]))
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
    -> (chords:[ChordMeasure], nextChord: ChordData) {
      // Filter out only the chord gens that can handle
      let chordGens = chordGenerators().filter {
        chordGenerator in
        return chordGenerator.0.canStartOnChord(startingChord, numberOfMeasures: numberOfMeasures)
      }
      let chordGenerator = RandomHelpers.randomElementFromWeightedList(chordGens)
      return chordGenerator.generateNextChords(startingChord: startingChord, numberOfMeasures: numberOfMeasures, scale: scale)
  }
  
  // TODO: This should return an array of classes. See below
  class func chordGenerators() -> [(ChordGenProtocol, weight: Int)] {
    return [
      (TwoFiveOneChordGen(), weight: 1), // TODO: Make more important?
      (AscendingDimChordGen(), weight: 1)
    ]
  }

//  class func chordGenerators() -> [(ChordGenProtocol.Type, weight: Int)] {
//    return [
//      (TwoFiveOneChordGen.self, weight: 2),
//      (AscendingDimChordGen.self, weight: 2) // TODO: CHANGE TO 1
//    ]
//  }
  
  /*
    Helps deal with 2 and 4 measure phrases
  
    The beats in the array must add up to 4.
    Measures must be either 2 or 4
  */
  class func chordMeasuresFromChords(chords: [(ChordData, beats: Int)], measures: Int) -> [ChordMeasure] {
    var chordMeasures = [ChordMeasure]()
    if measures == 2 {
      var beats = 0
      var currentChords = [ChordData]()
      for chord in chords {
        currentChords.append(chord.0)
        beats += chord.beats
        if beats == 2 {
          // Add this measure
          let measureChords: [(chord: ChordData, beats: Float)] = currentChords.map {
            chord in
            return (chord, Float(4 / currentChords.count))
          }
          chordMeasures.append(ChordMeasure(chords: measureChords))
          // Reset
          currentChords = [ChordData]()
          beats = 0
        }
      }
    } else {
      for chord in chords {
        for _ in 0..<chord.beats {
          chordMeasures.append(ChordMeasure(chords: [(chord.0, 4)]))
        }
      }
    }
    
    assert(chordMeasures.count == measures)
    
    return chordMeasures
  }
}



//
//  JazzChordGenerator.swift
//  TestAudio
//
//  Created by Peter Livesey on 6/16/14.
//  Copyright (c) 2014 Peter Livesey. All rights reserved.
//

import Foundation

let scale: [(note: Int, type: ChordType)] = [
  (0, .Major7),
  (2, .Minor7),
  (4, .Minor7),
  (5, .Major7),
  (7, .Dom7),
  (9, .Minor7),
  (11, .DimPartial)
]

class JazzChordGenerator {
  
  class func generateRandomChords(#numMeasures: Int, key: Int) -> [ChordMeasure] {
    assert(key >= 0 && key < 12)
    let cChords = generateRandomChords(numMeasures: numMeasures)
    return cChords.map { measure in
      let newChords: [(chord: ChordData, beats: Float)] = measure.chords.map { chord in
        return (chord.chord.transposedChord(key), chord.beats)
      }
      return ChordMeasure(chords: newChords)
    }
  }
  
  class func generateRandomChords(#numMeasures: Int) -> [ChordMeasure] {
    var nextChord = ChordFactory.IChord(key: .C)
    var chords = [ChordMeasure]()
    while (countElements(chords) < numMeasures) {
      if (countElements(chords) == numMeasures - 4) {
        let result = generateEndingChordsStarting(nextChord, numberOfMeasures: 4)
        chords += result
      } else if (countElements(chords) == numMeasures - 2) {
        let result = generateEndingChordsStarting(nextChord, numberOfMeasures: 2)
        chords += result
      } else {
        let numberOfMeasures = (arc4random_uniform(2)+1)*2
        let result = generateNextChords(startingChord: nextChord, numberOfMeasures: Int(numberOfMeasures))
        nextChord = result.nextChord
        chords += result.chords
      }
    }
    return chords
  }
  
  class func generateEndingChordsStarting(startingChord: ChordData, numberOfMeasures: Int) -> [ChordMeasure] {
    let destination = ChordFactory.IChord(key: .C)
    let chordGens = endingChordGenerators().filter {
      chordGenerator in
      return chordGenerator.0.canGenerateEndingStartingOnChord(startingChord, numberOfMeasures: numberOfMeasures, destination: destination)
    }
    let chordGenerator = RandomHelpers.randomElementFromWeightedList(chordGens)
    return chordGenerator.generateEndingChords(startingChord: startingChord, numberOfMeasures: numberOfMeasures, destination: destination)
  }
  
  class func endingChordGenerators() -> [(ChordEndingGenProtocol, weight: Int)] {
    return [
      (TwoFiveOneChordGen(), weight: 4),
      (FiveOverOneEndingChordGen(), weight: 1),
      (FiveOfFiveEndingChordGen(), weight: 1),
      (SevenDimChordEndingGen(), weight: 1),
      (FiveSusChordEndingGen(), weight: 1),
      (FlatSevenDiminishedEndingChordGen(), weight: 1),
      (TwoFiveTwoFiveEndingChordGen(), weight: 2),
      (TwoSevenTwoFiveOneEndingChordGen(), weight: 1)
    ]
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
      (TwoFiveOneChordGen(), weight: 100), // TODO: Make more important?
      (AscendingDimChordGen(), weight: 30),
      (StrayCatStrutChordGen(), weight: 50),
      (RhythmChangesOneChordGen(), weight: 70),
      (RhythmChangesTwoChordGen(), weight: 70),
      (ToFlatVIIChordGen(), weight: 60),
      (ClassicalStateMachineChordGen(), weight: 100),
      (SubdominantChordGen(), weight: 30),
      (Circle5ChordGen(), weight: 20)
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



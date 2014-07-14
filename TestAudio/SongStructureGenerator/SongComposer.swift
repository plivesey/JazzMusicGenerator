//
//  SongStructureGenerator.swift
//  TestAudio
//
//  Created by Peter Livesey on 7/14/14.
//  Copyright (c) 2014 Peter Livesey. All rights reserved.
//

import Foundation

class SongComposer {
  
  class func generateMelodyForChordMeasures(chordMeasures: [ChordMeasure], startNote: Int8, endNote: Int8) -> [MelodyMeasure] {
    
    let numberOfMeasures = chordMeasures.count
    assert(numberOfMeasures % 4 == 0)
    
    // Keep rhythm the same for every 4 note
    var rhythm = MelodyRhythmGenerator.rhythmMeasuresWithNumber(3, solo: false)
    rhythm.append(MelodyRhythmGenerator.transitionRhythm())
    
    var measures: [MelodyMeasure] = []
    var start = startNote
    for index in 0..<numberOfMeasures/4 {
      var end = start - 7 + Int8(RandomHelpers.randomNumberInclusive(0, 14))
      if index == numberOfMeasures/4 - 1 {
        end = endNote
      }
      
      let chords = Array(chordMeasures[index*4..<(index+1)*4])
      let nextMelody = JazzMelodyGenerator.generateMelodyMeasuresFromChordMeasures(chords, startingNote: start, endingNote: end, rhythm: rhythm, solo: false)
      measures.extend(nextMelody)
      
      start = end
    }
    return measures
  }
  
  class func generateSoloSection(chordMeasures: [ChordMeasure], startNote: Int8, endNote: Int8) -> [MelodyMeasure] {
    
    assert(chordMeasures.count % 2 == 0)
    
    let numberOfMeasures = chordMeasures.count
    
    var measures: [MelodyMeasure] = []
    var start = startNote
    
    var repeatedRhythm = MelodyRhythmGenerator.rhythmMeasuresWithNumber(2, solo: true, state: .Medium)
    
    for index in 0..<numberOfMeasures / 2 {
      var end = newSoloStartNote(start)
      if index == numberOfMeasures/2 - 1 {
        end = endNote
      }
      
      let randPercent = RandomHelpers.randomNumberInclusive(0, 99)
      
      if index == 0 || randPercent < 60 {
        
        let chords = Array(chordMeasures[index*2..<(index+1)*2])
        
        if RandomHelpers.randomNumberInclusive(0, 1) == 0 {
          // Generate a new rhythm
          repeatedRhythm = MelodyRhythmGenerator.rhythmMeasuresWithNumber(2, solo: true, state: repeatedRhythm.nextState)
        }
        
        let nextMelody = JazzMelodyGenerator.generateMelodyMeasuresFromChordMeasures(chords, startingNote: start, endingNote: end, rhythm: repeatedRhythm.rhythm, solo: true)
        measures.extend(nextMelody)
        
      } else if randPercent < 30 {
        // Generate a transposed melody
        let rhythm = MelodyRhythmGenerator.rhythmMeasuresWithNumber(1, solo: true, state: repeatedRhythm.nextState).rhythm
        
        // First part
        let firstChords = [chordMeasures[index*2]]
        let firstMelody = JazzMelodyGenerator.generateMelodyMeasuresFromChordMeasures(firstChords, startingNote: start, endingNote: end, rhythm: rhythm, solo: true)
        
        // Second part
        let secondChords = [chordMeasures[index*2 + 1]]
        let transpose = 7 + Int8(RandomHelpers.randomNumberInclusive(0, 14))
        let transposedMelody = MusicUtil.transposeMelody(firstMelody, delta: transpose)
        let secondMelody = MusicUtil.transformedMelody(transposedMelody, fitToChords: secondChords)
        
        measures.extend(firstMelody)
        measures.extend(secondMelody)
      } else {
        // Take some space
        let chords = Array(chordMeasures[index*2..<(index+1)*2])
        
        let rhythm = [repeatedRhythm.rhythm[0], MelodyRhythmGenerator.transitionRhythm()]
        
        let nextMelody = JazzMelodyGenerator.generateMelodyMeasuresFromChordMeasures(chords, startingNote: start, endingNote: end, rhythm: rhythm, solo: true)
        measures.extend(nextMelody)
      }
      
      start = end
    }
    
    assert(measures.count == chordMeasures.count)
    return measures
  }
  
  class func newSoloStartNote(current: Int8) -> Int8 {
    var next = current - 7 + Int8(RandomHelpers.randomNumberInclusive(0, 14))
    if next > 100 {
      return 110
    }
    if next < 60 {
      return 60
    }
    return next
  }
}

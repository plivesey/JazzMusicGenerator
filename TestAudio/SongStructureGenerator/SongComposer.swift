//
//  SongStructureGenerator.swift
//  TestAudio
//
//  Created by Peter Livesey on 7/14/14.
//  Copyright (c) 2014 Peter Livesey. All rights reserved.
//

import Foundation

class SongComposer {
  
  class func generateMelodyForChordMeasures(chordMeasures: [ChordMeasure], startNote: Int, endNote: Int) -> [MelodyMeasure] {
    
    let numberOfMeasures = chordMeasures.count
    assert(numberOfMeasures % 4 == 0)
    
    // Keep rhythm the same for every 4 note except the last measure
    let rhythmStart = MelodyRhythmGenerator.rhythmMeasuresWithNumber(3, solo: false)
    
    var measures: [MelodyMeasure] = []
    var start = startNote
    for index in 0..<numberOfMeasures/4 {
      var end = start - 7 + Int(RandomHelpers.randomNumberInclusive(0, 14))
      if index == numberOfMeasures/4 - 1 {
        end = endNote
      }
      
      let chords = Array(chordMeasures[index*4..<(index+1)*4])
      let rhythm = rhythmStart + [MelodyRhythmGenerator.transitionRhythm()]
      let nextMelody = JazzMelodyGenerator.generateMelodyMeasuresFromChordMeasures(chords, startingNote: start, endingNote: end, rhythm: rhythm, solo: false)
      measures.extend(nextMelody)
      
      start = end
    }
    return measures
  }
  
  class func generateSoloSection(chordMeasures: [ChordMeasure], startNote: Int, endNote: Int) -> [MelodyMeasure] {
    
    assert(chordMeasures.count % 2 == 0)
    
    let numberOfMeasures = chordMeasures.count
    
    var measures: [MelodyMeasure] = []
    var start = startNote
    
    var repeatedRhythm = MelodyRhythmGenerator.rhythmMeasuresWithNumber(2, solo: true, state: .Medium)
    
    for index in 0..<numberOfMeasures / 2 {
      var suggestedEnd = newSoloStartNote(start)
      if index == numberOfMeasures/2 - 1 {
        suggestedEnd = endNote
      }
      
      let chords = Array(chordMeasures[index*2..<(index+1)*2])
      
      let randPercent = RandomHelpers.randomNumberInclusive(0, 99)
      
      if index == 0 || index == numberOfMeasures/2 - 1 || randPercent < 50 {
        // Totally new section. Always do at the start and the end
        
        if RandomHelpers.randomNumberInclusive(0, 1) == 0 {
          // Generate a new rhythm
          repeatedRhythm = MelodyRhythmGenerator.rhythmMeasuresWithNumber(2, solo: true, state: repeatedRhythm.nextState)
        }
        
        let nextMelody = JazzMelodyGenerator.generateMelodyMeasuresFromChordMeasures(chords, startingNote: start, endingNote: suggestedEnd, rhythm: repeatedRhythm.rhythm, solo: true)
        measures.extend(nextMelody)
        
        start = suggestedEnd
        
      } else if randPercent < 70 {
        // Take a previous passage and play it again but transposed
        let measureIndex = RandomHelpers.randomNumberFromRange(0..<(measures.count/2))
        
        var originalMelody = Array(measures[measureIndex * 2...measureIndex * 2 + 1])
        if RandomHelpers.randomNumberInclusive(0, 1) == 0 {
          // 50/50 Chance
          originalMelody = MusicUtil.invertedMelody(originalMelody)
        }
        
        // Start is 81, previous note is 77. Delta should be 4
        let delta = start - originalMelody[0].notes[0].note
        
        let transposedMeasures = MusicUtil.transposeMelody(originalMelody, delta: delta)
        let actualMeasures = MusicUtil.transformedMelody(transposedMeasures, fitToChords: chords)
        
        measures.extend(actualMeasures)
        
        let lastMeasure = actualMeasures[actualMeasures.count - 1]
        let lastNote = lastMeasure.notes[lastMeasure.notes.count - 1].note
        
        start = Int(RandomHelpers.randomNumberInclusive(0, 1) * 2 - 1) + lastNote
        
      } else if randPercent < 90 {
        // Generate a transposed melody
        let rhythm = MelodyRhythmGenerator.rhythmMeasuresWithNumber(1, solo: true, state: repeatedRhythm.nextState).rhythm
        
        // First part
        let firstChords = [chordMeasures[index*2]]
        let firstMelody = JazzMelodyGenerator.generateMelodyMeasuresFromChordMeasures(firstChords, startingNote: start, endingNote: suggestedEnd, rhythm: rhythm, solo: true)
        
        // Second part
        let secondChords = [chordMeasures[index*2 + 1]]
        let transpose = 5 + Int(RandomHelpers.randomNumberInclusive(0, 10))
        
        var originalMelody = firstMelody
        if RandomHelpers.randomNumberInclusive(0, 1) == 0 {
          // 50/50 Chance
          originalMelody = MusicUtil.invertedMelody(originalMelody)
        }
        
        let transposedMelody = MusicUtil.transposeMelody(originalMelody, delta: transpose)
        let secondMelody = MusicUtil.transformedMelody(transposedMelody, fitToChords: secondChords)
        
        measures.extend(firstMelody)
        measures.extend(secondMelody)
        
        start = suggestedEnd
      } else {
        // Take some space
        let rhythm = [repeatedRhythm.rhythm[0], MelodyRhythmGenerator.transitionRhythm()]
        
        let nextMelody = JazzMelodyGenerator.generateMelodyMeasuresFromChordMeasures(chords, startingNote: start, endingNote: suggestedEnd, rhythm: rhythm, solo: true)
        measures.extend(nextMelody)
        
        start = suggestedEnd
      }
    }
    
    assert(measures.count == chordMeasures.count)
    return measures
  }
  
  class func newSoloStartNote(current: Int) -> Int {
    var next = current - 7 + Int(RandomHelpers.randomNumberInclusive(0, 14))
    if next > 100 {
      return 110
    }
    if next < 60 {
      return 60
    }
    return next
  }
}

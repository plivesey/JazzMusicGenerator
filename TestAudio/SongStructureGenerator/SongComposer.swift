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
    
    let numberOfMeasures = chordMeasures.count
    
    // Keep rhythm the same for every 4 note
    let rhythm = MelodyRhythmGenerator.rhythmMeasuresWithNumber(numberOfMeasures, solo: true)
    
    let melody = JazzMelodyGenerator.generateMelodyMeasuresFromChordMeasures(chordMeasures, startingNote: startNote, endingNote: endNote, rhythm: rhythm, solo: true)
    
    return melody
  }
  
  func dummy() {
//    var rhythmState = MelodyRhythmGenerator.Speed.Slow
//    if solo {
//      rhythmState = MelodyRhythmGenerator.Speed.Medium
//    }
//    var rhythms: [[Float]] = []
//    
//    var count = 6
//    if solo {
//      // Totally random
//      count = melodyOutline.count * 2
//    }
//    
//    for _ in 0..<count {
//      let rhythmTuple = MelodyRhythmGenerator.rhythmForState(rhythmState, solo: solo)
//      rhythms.append(rhythmTuple.rhythm)
//      rhythmState = rhythmTuple.nextState
//    }
//    
//    var measuresLeftBeforeEnd = 3
//    var rhythmIndex = 0
//    
//    for i in 0..<melodyOutline.count {
//      let melodyMeasure = melodyOutline[i]
//      let chordMeasure = chordMeasures[i]
//      
//      var notes = [MelodyNote]()
//      
//      if measuresLeftBeforeEnd == 0 && !solo {
//        notes.append((melodyMeasure.notes[0].note, 2))
//        notes.append((-1, 2))
//        measuresLeftBeforeEnd = 3
//        rhythmIndex = 0
//      } else {
//        measuresLeftBeforeEnd--
//        
//        var currentBeat: Float = 0
//        
//        assert(melodyMeasure.notes.count <= 2)
//        
//        for noteIndex in 0..<melodyMeasure.notes.count {
//          let beats: Float = 2
//          let currentNote = melodyMeasure.notes[noteIndex].note
//          var destinationNote = MusicUtil.findNextNoteInMelody(melodyOutline, measureIndex: i, noteIndex: noteIndex)
//          // TODO: This is a hack. If there's nothing at the end, should go towards start
//          if destinationNote == -1 {
//            destinationNote = 76
//          }
//          
//          var chord = chordMeasure.chords[0].chord
//          if (currentBeat >= 2) {
//            chord = chordBeat3(chordMeasure)
//          }
//          
//          // 50% main scale, 50% random scale (maybe main scale)
//          var scale = chord.mainChordScale
//          // TODO: Previously always did this if a solo. Put it back in?
//          if RandomHelpers.randomNumberInclusive(0, 1) == 1 {
//            scale = chord.chordScale.randomElement()
//          }
//          
//          let rhythm = rhythms[rhythmIndex++]
//          
//          let melody = melodyNotes(startNote: currentNote, destinationNote: destinationNote, beats: beats, scale: scale, rhythm: rhythm)
//          notes.extend(melody)
//          
//          currentBeat += beats
//        }
//      }
//      
//      measures.append(MelodyMeasure(notes: notes))
//    }
  }
}

//
//  ClassicalStateMachineChordGen.swift
//  TestAudio
//
//  Created by Peter Livesey on 7/12/14.
//  Copyright (c) 2014 Peter Livesey. All rights reserved.
//

import Foundation

class ClassicalStateMachineChordGen: ChordGenProtocol {
  
  enum ChordNumber {
    case I
    case ii
    case iii
    case iv
    case IV
    case V
    case vi
    case vii
  }
  
  func canStartOnChord(chord: ChordData, numberOfMeasures: Int) -> Bool {
    return chord.type == ChordType.Major7 ||
      chord.type == ChordType.Minor7 ||
      chord.type == ChordType.Dom7 ||
      chord.type == ChordType.DimPartial
  }
  
  func generateNextChords(#startingChord: ChordData, numberOfMeasures: Int, scale: [(note: Int, type: ChordType)]) -> (chords:[ChordMeasure], nextChord: ChordData) {
    let initial = firstChord(startingChord)
    let key = ChordFactory.CBasedNote(rawValue: initial.transposition % 12)!
    var state = initial.state
    
    var states: [ChordNumber] = [ ]
    for _ in 0..<3 {
      state = nextStateFromState(state)
      states.append(state)
    }
    let destinationState = nextStateFromState(state)
    let destinationChord = chordFromState(destinationState, key: key)
    
    var chords = [ startingChord ]
    let nextChords: [ChordData] = states.map {
      state in
      return self.chordFromState(state, key: key)
    }
    chords.extend(nextChords)
    
    let chordsWithBeats: [(ChordData, beats: Int)] = chords.map {
      chord in
      return (chord, beats: 1)
    }
    
    let measures = JazzChordGenerator.chordMeasuresFromChords(chordsWithBeats, measures: numberOfMeasures)
    return (measures, destinationChord)
  }
  
  func nextStateFromState(state: ChordNumber) -> ChordNumber {
    var possibleStates: [ChordNumber] = []
    switch state {
    case .I:
      possibleStates = [ .ii, .iii, .IV, .V, .vi, .vii ]
    case .ii:
      possibleStates = [ .V, .vii ]
    case .iii:
      possibleStates = [ .vi, .IV ]
    case .iv:
      possibleStates = [ .iii , .V ]
    case .IV:
      possibleStates = [ .ii, .V , .iv ]
    case .V:
      // Double the vi's chances because it's a cool place to go
      possibleStates = [ .vi, .vi, .I, .vii ]
    case .vi:
      possibleStates = [ .ii, .IV, .V ]
    case .vii:
      possibleStates = [ .I ]
    }
    return possibleStates.randomElement()
  }
  
  func chordFromState(state: ChordNumber, key: ChordFactory.CBasedNote) -> ChordData {
    var possibleChords: [ChordData] = []
    switch state {
    case .I:
      possibleChords = [
        ChordFactory.IChord(key: key),
        ChordFactory.IChordMajor9(key: key)
      ]
    case .ii:
      possibleChords = [
        ChordFactory.iiChordMajorABForm(key: key),
        ChordFactory.iiChord(key: key)
      ]
    case .iii:
      possibleChords = [
        ChordFactory.iiiChord(key: key)
      ]
    case .iv:
      // Minor iv
      possibleChords = [
        ChordFactory.ivChord(key: key)
      ]
    case .IV:
      possibleChords = [
        ChordFactory.IVChord(key: key)
      ]
    case .V:
      // Double the vi's chances because it's a cool place to go
      possibleChords = [
        ChordFactory.VChordMajorABForm(key: key)
      ]
    case .vi:
      possibleChords = [
        ChordFactory.viChord(key: key)
      ]
    case .vii:
      possibleChords = [
        ChordFactory.viiChord(key: key)
      ]
    }
    return possibleChords.randomElement()
  }

  func firstChord(chord: ChordData) -> (state: ChordNumber, transposition: Int) {
    
    // TODO: REMOVE THIS MADNESS
    struct Temp {
      let state: ChordNumber
      let transposition: Int
      
      init(_ state: ChordNumber, _ transpose: Int) {
        self.state = state
        self.transposition = transpose
      }
    }
    
    var possibleAnswers: [Temp] = []
    if chord.type == ChordType.Major7 {
      // Could be a I or a IV
      possibleAnswers = [
        Temp(.I, chord.baseNote),
        Temp(.IV, (chord.baseNote - 5 + 12) % 12)]
    } else if chord.type == ChordType.Minor7 {
      possibleAnswers = [
        Temp(.ii, (chord.baseNote - 2 + 12) % 12),
        Temp(.iii, (chord.baseNote - 4 + 12) % 12),
        Temp(.vi, (chord.baseNote - 9 + 12) % 12)]
    } else if chord.type == ChordType.Dom7 {
      possibleAnswers = [Temp(.V, (chord.baseNote - 7 + 12) % 12)]
    } else if chord.type == ChordType.DimPartial {
      possibleAnswers = [Temp(.vii, (chord.baseNote + 1) % 12)]
    }
    let answer = possibleAnswers.randomElement()
    return (answer.state, answer.transposition)
  }
}

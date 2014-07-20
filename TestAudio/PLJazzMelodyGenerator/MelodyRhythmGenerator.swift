//
//  MelodyRhythmGenerator.swift
//  TestAudio
//
//  Created by Peter Livesey on 7/9/14.
//  Copyright (c) 2014 Peter Livesey. All rights reserved.
//

import Foundation

struct RhythmMeasure {
  let rhythms: [[Float]]
  
  init(rhythms: [[Float]]) {
    assert(rhythms.count == 2)
    self.rhythms = rhythms
  }
}

class MelodyRhythmGenerator {
  enum Speed {
    case Slow
    case Medium
    case Fast
    case ExtendedFast
  }
  
  class func rhythmMeasuresWithNumber(number: Int, solo: Bool) -> [RhythmMeasure] {
    // Default to medium speed
    return MelodyRhythmGenerator.rhythmMeasuresWithNumber(number, solo: solo, state: .Medium).rhythm
  }
  
  class func rhythmMeasuresWithNumber(number: Int, solo: Bool, state: Speed) -> (rhythm: [RhythmMeasure], nextState: Speed) {
    var measures: [RhythmMeasure] = []
    var state = Speed.Medium
    for _ in 0..<number {
      var rhythms: [[Float]] = []
      for _ in 0..<2 {
        let next = rhythmForState(state, solo: solo)
        state = next.nextState
        rhythms.append(next.rhythm)
      }
      measures.append(RhythmMeasure(rhythms: rhythms))
    }
    
    assert(measures.count == number)
    return (measures, state)
  }
  
  class func rhythmForState(state: Speed, solo: Bool) -> (rhythm: [Float], nextState: Speed) {
    let rhythms = twoBeatRhythmForSpeed(state)
    
    if solo {
      switch state {
      case .Slow:
        return (rhythms, Speed.Medium)
      case .Medium:
        let rand = RandomHelpers.randomNumberInclusive(0, 9)
        if rand < 3 {
          return (rhythms, Speed.Slow)
        } else if rand < 4 {
          return (rhythms, Speed.Medium)
        } else if rand < 5 {
          return (rhythms, Speed.ExtendedFast)
        } else {
          return (rhythms, Speed.Fast)
        }
      case .Fast:
        let rand = RandomHelpers.randomNumberInclusive(0, 9)
        if rand < 3 {
          return (rhythms, Speed.Fast)
        } else if rand < 6 {
          return (rhythms, Speed.ExtendedFast)
        } else {
          return (rhythms, Speed.Medium)
        }
      case .ExtendedFast:
        if RandomHelpers.randomNumberInclusive(0, 9) < 3 {
          return (rhythms, Speed.Medium)
        }
        return (rhythms, Speed.ExtendedFast)
      }
    } else {
      switch state {
      case .Slow:
        if RandomHelpers.randomNumberInclusive(0, 10) < 3 {
          return (rhythms, Speed.Slow)
        } else {
          return (rhythms, Speed.Medium)
        }
      case .Medium:
        if RandomHelpers.randomNumberInclusive(0, 10) < 3 {
          return (rhythms, Speed.Slow)
        } else {
          return (rhythms, Speed.Medium)
        }
      case .Fast:
        return (rhythms, Speed.Medium)
      case .ExtendedFast:
        return (rhythms, Speed.Medium)
      }
    }
  }
  
  class func transitionRhythm() -> RhythmMeasure {
    return [
      RhythmMeasure(rhythms: [[2] , []]),
      RhythmMeasure(rhythms: [[2] , [2]]),
      RhythmMeasure(rhythms: [[1, 1] , []]),
      RhythmMeasure(rhythms: [[1, 1] , [2]]),
      RhythmMeasure(rhythms: [[1.66, 0.34] , []]),
      RhythmMeasure(rhythms: [[1.66, 0.34] , [2]]),
      RhythmMeasure(rhythms: [[0.66, 1, 0.34] , [2]]),
      ].randomElement()
  }
  
  class func twoBeatRhythmForSpeed(speed: Speed) -> [Float] {
    switch speed {
    case .Slow:
      return [
        [ 2 ],
        [ 1, 1 ],
        [ 1.33, 0.67 ]
        ].randomElement()
    case .Medium:
      return [
        [ 1.66, 0.34 ],
        [ 0.67, 0.67, 0.66 ],
        [ 1, 0.66, 0.34 ],
        [ 0.66, 0.34, 1 ],
        [ 0.67, 0.67, 0.66 ],
        [ 1, 0.33, 0.33, 0.34 ]
        ].randomElement()
    case .Fast:
      return [
        [ 0.66, 0.34, 0.66, 0.34 ],
        [ 0.33, 0.33, 0.67, 0.33, 0.34 ],
        [ 0.33, 0.33, 0.34, 0.33, 0.33, 0.34 ],
        [ 0.25, 0.25, 0.25, 0.25, 0.33, 0.33, 0.34 ],
        [ 0.33, 0.33, 0.34, 0.25, 0.25, 0.25, 0.25 ],
        [ 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25 ]
        ].randomElement()
    case .ExtendedFast:
      return [ 0.33, 0.33, 0.34, 0.33, 0.33, 0.34 ]
    }
  }
}



//
//  MelodyRhythmGenerator.swift
//  TestAudio
//
//  Created by Peter Livesey on 7/9/14.
//  Copyright (c) 2014 Peter Livesey. All rights reserved.
//

import Foundation

class MelodyRhythmGenerator {
  enum Speed {
    case Slow
    case Medium
    case Fast
    case ExtendedFast
  }
  
  class func rhythmForState(state: Speed, solo: Bool) -> (rhythm: Float[], nextState: Speed) {
    let rhythms = twoBeatRhythmForSpeed(state)
    
    if solo {
      switch state {
      case .Slow:
        return (rhythms, Speed.Medium)
      case .Medium:
        let rand = randomNumberInclusive(0, 10)
        if rand == 1 {
          return (rhythms, Speed.Slow)
        } else if rand < 3 {
          return (rhythms, Speed.Medium)
        } else if rand < 6 {
          return (rhythms, Speed.ExtendedFast)
        } else {
          return (rhythms, Speed.Fast)
        }
      case .Fast:
        let rand = randomNumberInclusive(0, 10)
        if rand < 4 {
          return (rhythms, Speed.Fast)
        } else if rand < 6 {
          return (rhythms, Speed.ExtendedFast)
        } else {
          return (rhythms, Speed.Medium)
        }
      case .ExtendedFast:
        if randomNumberInclusive(0, 10) < 3 {
          return (rhythms, Speed.Medium)
        }
        return (rhythms, Speed.ExtendedFast)
      }
    } else {
      switch state {
      case .Slow:
        if randomNumberInclusive(0, 10) < 3 {
          return (rhythms, Speed.Slow)
        } else {
          return (rhythms, Speed.Medium)
        }
      case .Medium:
        if randomNumberInclusive(0, 10) < 3 {
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
  
  class func twoBeatRhythmForSpeed(speed: Speed) -> Float[] {
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



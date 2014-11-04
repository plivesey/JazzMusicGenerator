//
//  MusicUtil+Scales.swift
//  TestAudio
//
//  Created by Peter Livesey on 7/14/14.
//  Copyright (c) 2014 Peter Livesey. All rights reserved.
//

import Foundation

extension MusicUtil {
  
  // Returns a zero based scale
  // Keeps the current order so it will not be always ascending
  class func zeroBasedScale(scale: [Int]) -> [Int] {
    return scale.map {
      note in return note % 12
    }
  }
  
  class func scaleWithScale(scale: [Int], differentMode mode: Int) -> [Int] {
    var newScale: [Int] = []
    var currentIndex = mode
    var addition = 0
    while newScale.count < scale.count {
      newScale.append(scale[currentIndex] + addition)
      currentIndex++
      if currentIndex >= scale.count {
        currentIndex = 0
        addition = 12
      }
    }
    if newScale[0] >= 12 {
      newScale = newScale.map { note in
        return note - 12
      }
    }
    return newScale
  }

  class func transposedScale(scale: [Int], transposition: Int) -> [Int] {
    assert(transposition >= 0 && transposition < 12)
    var newScale: [Int] = scale.map { note in
      return note + transposition
    }
    if newScale[0] >= 12 {
      newScale = newScale.map { note in
        return note - 12
      }
    }
    return newScale
  }
}

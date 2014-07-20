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
}

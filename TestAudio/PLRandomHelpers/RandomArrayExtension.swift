//
//  RandomArrayExtension.swift
//  TestAudio
//
//  Created by Peter Livesey on 6/16/14.
//  Copyright (c) 2014 Peter Livesey. All rights reserved.
//

import Foundation

extension Array {
  func randomElement() -> T {
    let index = arc4random_uniform(UInt32(countElements(self)))
    return self[Int(index)]
  }
}

func randomNumberInclusive(min: Int, max: Int) -> Int {
  return Int(arc4random_uniform(UInt32(max)-UInt32(min)+1) + UInt32(min))
}

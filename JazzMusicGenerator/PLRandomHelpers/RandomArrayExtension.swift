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

public class RandomHelpers {
  public class func randomNumberInclusive(min: Int, _ max: Int) -> Int {
    return Int(arc4random_uniform(UInt32(max)-UInt32(min)+1) + UInt32(min))
  }
  
  /*
    Example: 2..4 should return 50/50 2 or 3
    This will be rand(3-2)+2
  */
  public class func randomNumberFromRange(range: Range<Int>) -> Int {
    return Int(arc4random_uniform(UInt32(range.endIndex - range.startIndex)) + UInt32(range.startIndex))
  }
  
  public class func randomElementFromWeightedList<T>(list: [(T, weight: Int)]) -> T {
    let sum = list.reduce(0) {
      current, nextElement in
        return current + nextElement.weight
    }
    let random = randomNumberFromRange(0..<sum)
    var currentSum = 0
    for element in list {
      currentSum += element.weight
      if currentSum > random {
        return element.0
      }
    }
    assert(false, "We should never get here")
    return list[0].0
  }
}


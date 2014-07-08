//
//  MelodyMeasure.swift
//  TestAudio
//
//  Created by Peter Livesey on 6/19/14.
//  Copyright (c) 2014 Peter Livesey. All rights reserved.
//

import Foundation

typealias MelodyNote = (note: Int8, beats: Float)

struct MelodyMeasure {
  let notes: MelodyNote[]
}

struct ChordNoteMeasure {
  let notes: ChordNote[]
}

struct ChordNote {
  let notes: Int8[]
  let beats: Float
}

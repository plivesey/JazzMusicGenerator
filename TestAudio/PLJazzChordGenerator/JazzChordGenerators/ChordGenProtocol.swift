//
//  ChordGenProtocol.swift
//  TestAudio
//
//  Created by Peter Livesey on 7/10/14.
//  Copyright (c) 2014 Peter Livesey. All rights reserved.
//

import Foundation

protocol ChordGenProtocol {
  class func canStartOnChord(chord: ChordData, numberOfMeasures: Int) -> Bool
  class func generateNextChords(#startingChord: ChordData, numberOfMeasures: Int, scale: (note: Int8, type: ChordType)[])
    -> (chords:ChordMeasure[], nextChord: ChordData)
}

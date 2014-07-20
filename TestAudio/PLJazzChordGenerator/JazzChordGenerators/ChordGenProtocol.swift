//
//  ChordGenProtocol.swift
//  TestAudio
//
//  Created by Peter Livesey on 7/10/14.
//  Copyright (c) 2014 Peter Livesey. All rights reserved.
//

import Foundation

protocol ChordGenProtocol {
  func canStartOnChord(chord: ChordData, numberOfMeasures: Int) -> Bool
  func generateNextChords(#startingChord: ChordData, numberOfMeasures: Int, scale: [(note: Int, type: ChordType)])
    -> (chords:[ChordMeasure], nextChord: ChordData)
}

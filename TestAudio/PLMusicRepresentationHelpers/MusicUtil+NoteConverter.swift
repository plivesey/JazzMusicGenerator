//
//  MusicUtil+NoteConverter.swift
//  TestAudio
//
//  Created by Peter Livesey on 7/19/14.
//  Copyright (c) 2014 Peter Livesey. All rights reserved.
//

import Foundation

extension MusicUtil {
  class func UInt8MusicRepresentation(var note: Int) -> UInt8 {
    while note >= 128 {
      note -= 12
    }
    while note < 0 {
      note += 12
    }
    return UInt8(note)
  }
}

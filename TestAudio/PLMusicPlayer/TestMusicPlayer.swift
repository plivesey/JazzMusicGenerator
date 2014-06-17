//
//  TestMusicPlayer.swift
//  TestAudio
//
//  Created by Peter Livesey on 6/15/14.
//  Copyright (c) 2014 Peter Livesey. All rights reserved.
//

import Foundation

func testMusicSimple() {
  // Chromatic scale
  var music = PLMusicPlayerNote[]()
  for i in 0..6 {
    let note = UInt8(i+48)
    let playerNote = PLMusicPlayerNote(note:note, velocity: 90, start:Float(i), duration:1, channel:0)
    music.append(playerNote)
  }
  // More chromatics, now with chords
  for i in 6..9 {
    let note = UInt8(i+48)
    let playerNote = PLMusicPlayerNote(note:note, velocity: 90, start:Float(i), duration:1, channel:0)
    music.append(playerNote)
    let note2 = UInt8(i+52)
    let playerNote2 = PLMusicPlayerNote(note:note2, velocity: 90, start:Float(i), duration:1, channel:0)
    music.append(playerNote2)
  }
  
  PLMusicPlayer.sharedInstance.playMusic(music, maxNumberOfTimers: 3)
}

func testEighthNotes() {
  // Chromatic scale with some eighth notes
  var music = PLMusicPlayerNote[]()
  var note: UInt8 = 48
  for i in 0..5 {
    let playerNote = PLMusicPlayerNote(note:note++, velocity: 90, start:Float(i)/2, duration:0.5, channel:0)
    music.append(playerNote)
    println("Start: \(playerNote.start) Note: \(playerNote.note)")
  }
  for i in 3..5 {
    let playerNote = PLMusicPlayerNote(note:note++, velocity: 90, start:Float(i), duration:0.5, channel:0)
    music.append(playerNote)
    println("Start: \(playerNote.start) Note: \(playerNote.note)")
  }
  for i in 10..14 {
    let playerNote = PLMusicPlayerNote(note:note++, velocity: 90, start:Float(i)/2, duration:0.5, channel:0)
    music.append(playerNote)
    println("Start: \(playerNote.start) Note: \(playerNote.note)")
  }
  
  PLMusicPlayer.sharedInstance.playMusic(music, maxNumberOfTimers: 5)
}

func testDuplicateNotes() {
  var music = PLMusicPlayerNote[]()
  for i in 0..10 {
    let playerNote = PLMusicPlayerNote(note:48, velocity: 90, start:Float(i)/2, duration:2.3, channel:0)
    music.append(playerNote)
  }
  PLMusicPlayer.sharedInstance.playMusic(music, maxNumberOfTimers: 5)
}


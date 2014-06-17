
//
//  PLMusicPlayer.swift
//  TestAudio
//
//  Created by Peter Livesey on 6/14/14.
//  Copyright (c) 2014 Peter Livesey. All rights reserved.
//

// Frameworks
import Foundation
import AVFoundation


class PLMusicPlayer {
  // Private
  let audioEngine = AVAudioEngine()
  
  let instrument: AVAudioUnitMIDIInstrument
  
  class var sharedInstance:PLMusicPlayer {
    get {
      struct StaticMusicPlayerContainer {
        static var instance : PLMusicPlayer? = nil
      }
      
      if !StaticMusicPlayerContainer.instance {
        StaticMusicPlayerContainer.instance = PLMusicPlayer()
      }
      
      return StaticMusicPlayerContainer.instance!
    }
  }
  
  init() {
    let mixer = audioEngine.mainMixerNode
    
    // Hack. This should be kAudioUnitType_MusicDevice, but doesn't compile currently
    let component: OSType = 1635085685
    
    let description = AudioComponentDescription(componentType: component,
      componentSubType: 0,
      componentManufacturer: 0,
      componentFlags: 0,
      componentFlagsMask: 0)
    instrument = AVAudioUnitMIDIInstrument(audioComponentDescription: description)
    
    audioEngine.attachNode(instrument)
    audioEngine.connect(instrument, to: mixer, format:instrument.outputFormatForBus(0))
    
    var error: NSError? = nil
    audioEngine.startAndReturnError(&error)
    if error {
      println("ERROR \(error)")
    }
  }
  
  func playMusic(music: PLMusicPlayerNote[], maxNumberOfTimers: Int) {
    playMusic(music, maxNumberOfTimers: maxNumberOfTimers, playedSoFar: 0)
  }
  
  func playMusic(music: PLMusicPlayerNote[], maxNumberOfTimers: Int, playedSoFar: Float) {
    // TODO: Clean up
    // TODO: Add a dictionary to handle duplicate notes
    var index = 0
    let dispatchNow = DISPATCH_TIME_NOW
    for _ in 0..maxNumberOfTimers {
      if (index >= countElements(music)) {
        break;
      }
      let chordTuple = nextChord(music, startIndex:index)
      
      let start = chordTuple.chord[0].start - playedSoFar
      let chord = chordTuple.chord
      index = chordTuple.nextIndex
      
      dispatchAccuratelyAfter(start, queue: dispatch_get_main_queue()) {
        for i in 0..countElements(chord) {
          let note = chord[i].note
          let velocity = chord[i].velocity
          self.instrument.startNote(note, withVelocity:velocity, onChannel:0)
        }
        dispatchAccuratelyAfter(chord[0].duration, queue:dispatch_get_main_queue()) {
          for i in 0..countElements(chord) {
            let note = chord[i].note
            self.instrument.stopNote(note, onChannel: 0)
          }
        }
      }
    }
    if (index < countElements(music)) {
      // Let's call this method again with the next part of the music
      var newMusic = PLMusicPlayerNote[]()
      
      for i in index..countElements(music) {
        newMusic.append(music[i])
      }
      let newStart = music[index].start
      
      dispatchAccuratelyAfter(newStart-playedSoFar, queue:dispatch_get_main_queue()) {
        self.playMusic(newMusic, maxNumberOfTimers:maxNumberOfTimers, playedSoFar:newStart)
      }
    }
  }
  
  func nextChord(music: PLMusicPlayerNote[], startIndex: Int) -> (chord: PLMusicPlayerNote[], nextIndex: Int) {
    var chord = PLMusicPlayerNote[]()
    let firstNote = music[startIndex]
    chord.append(firstNote)
    for i in startIndex+1..countElements(music) {
      if (music[i].start == firstNote.start) {
        chord.append(music[i])
      } else {
        // End of the chord, so let's return the chord and i
        return (chord, i)
      }
    }
    // We've reached the end of the music, so we'll return the count of the music array
    return (chord, countElements(music))
  }
}

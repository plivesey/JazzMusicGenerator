
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
  var playingNotes = Dictionary<UInt8, Int>()
  
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
    
    let description = AudioComponentDescription(componentType: OSType(kAudioUnitType_MusicDevice),
      componentSubType: 0, //OSType(kAudioUnitSubType_Sampler),
      componentManufacturer: OSType(kAudioUnitManufacturer_Apple),
      componentFlags: 0,
      componentFlagsMask: 0)
    
    instrument = AVAudioUnitMIDIInstrument(audioComponentDescription: description)
    
//    let soundBankPath = NSBundle.mainBundle().pathForResource("jazzBass", ofType: "sf2")
//    let soundBankURL = NSURL.fileURLWithPath(soundBankPath)
//    
//    let samplerAudioUnit = instrument.audioUnit
//    var result: OSStatus = OSStatus(noErr)
//    
//    // fill out a bank preset data structure
//    var bpData = AUSamplerBankPresetData(bankURL: Unmanaged<CFURL>(_private: soundBankURL), bankMSB: UInt8(kAUSampler_DefaultMelodicBankMSB), bankLSB: UInt8(kAUSampler_DefaultBankLSB), presetID: 1, reserved: 0)
//    
//    var bpDataPointer: CConstVoidPointer = &bpData
//    
//    // set the kAUSamplerProperty_LoadPresetFromBank property
//    result = AudioUnitSetProperty(samplerAudioUnit,
//      UInt32(kAUSamplerProperty_LoadPresetFromBank),
//      UInt32(kAudioUnitScope_Global),
//      0, bpDataPointer, 8)
    
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
    var index = 0
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
          self.instrument.startNote(note, withVelocity:velocity, onChannel:1)
          if let num = self.playingNotes[note] {
            self.playingNotes[note] = num + 1
          } else {
            self.playingNotes[note] = 1
          }
        }
        dispatchAccuratelyAfter(chord[0].duration, queue:dispatch_get_main_queue()) {
          for i in 0..countElements(chord) {
            let note = chord[i].note
            // We can unwrap this because we'll always have set this when we started the note
            self.playingNotes[note] = self.playingNotes[note]! - 1
            if (self.playingNotes[note] == 0) {
              self.instrument.stopNote(note, onChannel: 1)
            }
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
    let duration = firstNote.duration
    for i in startIndex+1..countElements(music) {
      if (music[i].start == firstNote.start && music[i].duration == firstNote.duration) {
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

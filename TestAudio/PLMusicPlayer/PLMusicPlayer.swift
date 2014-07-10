
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
  
  enum InstrumentType {
    case Piano
    case Bass
    case Sax
    case Drums
  }
  
  // Private
  let audioEngine = AVAudioEngine()
  // Instruments
  let piano: AVAudioUnitMIDIInstrument
  let bass: AVAudioUnitMIDIInstrument
  let sax: AVAudioUnitMIDIInstrument
  let drums: AVAudioUnitMIDIInstrument
  
  var playingNotes = Dictionary<PlayingNote, Int>()
  
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
    
    piano = PLMusicPlayer.instrumentWithFileName("Piano", presetID: 1)
    bass = PLMusicPlayer.instrumentWithFileName("jazzBass", presetID: 1)
    sax = PLMusicPlayer.instrumentWithFileName("sax", presetID: 0)
    drums = PLMusicPlayer.instrumentWithFileName("drums", presetID: 0)
    
    // Attach Instruments
    
    audioEngine.attachNode(bass)
    audioEngine.attachNode(piano)
    audioEngine.attachNode(sax)
    audioEngine.attachNode(drums)
    audioEngine.connect(bass, to: mixer, format:bass.outputFormatForBus(0))
    audioEngine.connect(piano, to: mixer, format: piano.outputFormatForBus(0))
    audioEngine.connect(sax, to: mixer, format: sax.outputFormatForBus(0))
    audioEngine.connect(drums, to: mixer, format: drums.outputFormatForBus(0))
    
    var error: NSError? = nil
    audioEngine.startAndReturnError(&error)
    if error {
      println("ERROR \(error)")
    }
  }
  
  class func instrumentWithFileName(fileName: String, presetID: UInt8) -> AVAudioUnitMIDIInstrument {
    let description = AudioComponentDescription(componentType: OSType(kAudioUnitType_MusicDevice),
      componentSubType: OSType(kAudioUnitSubType_Sampler),
      componentManufacturer: OSType(kAudioUnitManufacturer_Apple),
      componentFlags: 0,
      componentFlagsMask: 0)
    
    let instrument = AVAudioUnitMIDIInstrument(audioComponentDescription: description)
    
    let soundBankPath = NSBundle.mainBundle().pathForResource(fileName, ofType: "sf2")
    let soundBankURL = NSURL.fileURLWithPath(soundBankPath)
    
    let samplerAudioUnit = instrument.audioUnit
    var result = OSStatus(noErr)
    
    // fill out a bank preset data structure
    var bpData = AUSamplerBankPresetData(bankURL: Unmanaged<CFURL>(_private: soundBankURL), bankMSB: UInt8(kAUSampler_DefaultMelodicBankMSB), bankLSB: UInt8(kAUSampler_DefaultBankLSB), presetID: presetID, reserved: 0)
    
    let y: COpaquePointer!
    var x = ConstUnsafePointer<Void>()
    let bpDataPointer: ConstUnsafePointer<()> = ConstUnsafePointer()
    
//    let i = &bpData as ConstUnsafePointer
//    var bpDataPointer = UnsafePointer(i)
//    bpDataPointer.initialize(&bpData)
    
    // set the kAUSamplerProperty_LoadPresetFromBank property
    result = AudioUnitSetProperty(samplerAudioUnit,
      UInt32(kAUSamplerProperty_LoadPresetFromBank),
      UInt32(kAudioUnitScope_Global),
      0, &bpData, 8)
    
    return instrument
  }
  
  func playMusic(music: [PLMusicPlayerNote], maxNumberOfTimers: Int) {
    playMusic(music, maxNumberOfTimers: maxNumberOfTimers, playedSoFar: 0)
  }
  
  func playMusic(music: [PLMusicPlayerNote], maxNumberOfTimers: Int, playedSoFar: Float) {
    // TODO: Clean up
    var index = 0
    for _ in 0..<maxNumberOfTimers {
      if (index >= countElements(music)) {
        break;
      }
      let chordTuple = nextChord(music, startIndex:index)
      
      let start = chordTuple.chord[0].start - playedSoFar
      let chord = chordTuple.chord
      index = chordTuple.nextIndex
      
      dispatchAccuratelyAfter(start, queue: dispatch_get_main_queue()) {
        for i in 0..<countElements(chord) {
          let note = chord[i].note
          let velocity = chord[i].velocity
          switch chord[i].instrument {
          case .Piano:
            self.piano.startNote(note, withVelocity: velocity, onChannel: 1)
          case .Bass:
            self.bass.startNote(note, withVelocity: velocity, onChannel: 1)
          case .Sax:
            self.sax.startNote(note, withVelocity: velocity, onChannel: 1)
          case .Drums:
            self.drums.startNote(note, withVelocity: velocity, onChannel: 1)
          }
          
          let playingNote = PlayingNote(instrument: chord[i].instrument, note: note)
          
          if let num = self.playingNotes[playingNote] {
            self.playingNotes[playingNote] = num + 1
          } else {
            self.playingNotes[playingNote] = 1
          }
        }
        dispatchAccuratelyAfter(chord[0].duration, queue:dispatch_get_main_queue()) {
          for i in 0..<countElements(chord) {
            let playingNote = PlayingNote(instrument: chord[i].instrument, note: chord[i].note)
            // We can unwrap this because we'll always have set this when we started the note
            self.playingNotes[playingNote] = self.playingNotes[playingNote]! - 1
            if (self.playingNotes[playingNote] == 0) {
              switch playingNote.instrument {
              case .Piano:
                self.piano.stopNote(playingNote.note, onChannel: 1)
              case .Bass:
                self.bass.stopNote(playingNote.note, onChannel: 1)
              case .Sax:
                self.sax.stopNote(playingNote.note, onChannel: 1)
              case .Drums:
                self.drums.stopNote(playingNote.note, onChannel: 1)
              }
            }
          }
        }
      }
    }
    if (index < countElements(music)) {
      // Let's call this method again with the next part of the music
      var newMusic = [PLMusicPlayerNote]()
      
      for i in index..<countElements(music) {
        newMusic.append(music[i])
      }
      let newStart = music[index].start
      
      dispatchAccuratelyAfter(newStart-playedSoFar, queue:dispatch_get_main_queue()) {
        self.playMusic(newMusic, maxNumberOfTimers:maxNumberOfTimers, playedSoFar:newStart)
      }
    }
  }
  
  func nextChord(music: [PLMusicPlayerNote], startIndex: Int) -> (chord: [PLMusicPlayerNote], nextIndex: Int) {
    var chord = [PLMusicPlayerNote]()
    let firstNote = music[startIndex]
    chord.append(firstNote)
    let duration = firstNote.duration
    for i in startIndex+1..<countElements(music) {
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
  
  struct PlayingNote: Hashable {
    let instrument: InstrumentType
    let note: UInt8
    
    var hashValue: Int { get {
      // Using overflow operator
      return instrument.hashValue &+ note.hashValue
    }}
  }
}

func == (lhs: PLMusicPlayer.PlayingNote, rhs: PLMusicPlayer.PlayingNote) -> Bool {
  return lhs.instrument == rhs.instrument && lhs.note == rhs.note
}

//
//  MainViewController.swift
//  TestAudio
//
//  Created by Peter Livesey on 6/29/14.
//  Copyright (c) 2014 Peter Livesey. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
  
  let music: [PLMusicPlayerNote]
  let scoreText: String
  
  @IBOutlet var textView: UITextView
  
  init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
    
    let startNote = 70 + RandomHelpers.randomNumberInclusive(0, 11)
    
    let chords = JazzChordGenerator.generateRandomChords(numMeasures: 8)
    let melody = SongComposer.generateMelodyForChordMeasures(chords, startNote: startNote, endNote: startNote)
    let bassline = BasslineGenerator.generateBasslineForChordMeasures(chords)
    let rhythm = RhythmSectionGenerator.rhythmSectionFromChords(chords)
    let drums = DrumGenerator.generateDrums(numberOfMeasures: chords.count)
    
    let soloChords = JazzChordGenerator.generateRandomChords(numMeasures: 16)
    let soloMelody = SongComposer.generateSoloSection(soloChords, startNote: startNote, endNote: startNote)
    let soloBassline = BasslineGenerator.generateBasslineForChordMeasures(soloChords)
    let soloRhythm = RhythmSectionGenerator.rhythmSectionFromChords(soloChords)
    let soloDrums = DrumGenerator.generateDrums(numberOfMeasures: soloChords.count)
    
    let endChord = chords[0]
    let endMelody = [MelodyMeasure(notes: [(melody[0].notes[0].note, 4)])]
    let endBassline = [MelodyMeasure(notes: [(bassline[0].notes[0].note, 4)])]
    let endRhythm = [rhythm[0]]
    let endDrums = [ChordNoteMeasure(notes: [ChordNote(notes: [52], beats: 4)])]
    
    scoreText = ""
    for i in 0..<chords.count {
      
      scoreText += "---[\(i)]---\n"
      for chord in chords[i].chords {
        scoreText += "Playing chord: \(chord.chord) for beats: \(chord.beats)\n"
      }
      for note in melody[i].notes {
        let value = note.note
        let zeroBased = value % 12
        scoreText += "\(MusicUtil.noteToString(zeroBased)) (\(value)) - \(note.beats)\n"
      }
      scoreText += "\n"
    }
    
    scoreText += "Solo Chords: \n"
    
    let charsPerMeasure = 20
    for (measureIndex, measure) in enumerate(soloChords) {
      scoreText += "| "
      var measureText = ""
      for (chordIndex, chord) in enumerate(measure.chords) {
        if chordIndex > 0 {
          
          measureText += "- "
        }
        measureText += "\(chord.chord) "
      }
      
      var end = true
      while measureText.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) < charsPerMeasure {
        if end {
          measureText += " "
        } else {
          measureText = " " + measureText
        }
        end = !end
      }
      
      scoreText += measureText
      
      if measureIndex % 2 == 1 {
        scoreText += " |\n"
      }
    }
    
    let secondsPerBeat: Float = 0.5
    
    let main = createScore(chords: rhythm, melody: melody, bassline: bassline, drums: drums, secondsPerBeat: secondsPerBeat)
    let solo = createScore(chords: soloRhythm, melody: soloMelody, bassline: soloBassline, drums: soloDrums, secondsPerBeat: secondsPerBeat)
    let end = createScore(chords: endRhythm, melody: endMelody, bassline: endBassline, drums: endDrums, secondsPerBeat: secondsPerBeat)
    
    let sectionLength: Float = secondsPerBeat * 4 * 8
    
    var song: [PLMusicPlayerNote] = []
    song.extend(main)
    song.extend(main.map {
      (var x) in
      x.start = x.start + sectionLength
      return x
      })
    song.extend(solo.map {
      (var x) in
      x.start = x.start + sectionLength * 2
      return x
      })
    song.extend(main.map {
      (var x) in
      x.start = x.start + sectionLength * 4
      return x
      })
    song.extend(end.map {
      (var x) in
      x.start = x.start + sectionLength * 5
      return x
      })
    
    var soloLoop = solo
    for i in 1..<3 {
      soloLoop.extend(solo.map {
        (var x) in
        x.start = x.start + sectionLength * 2 * Float(i)
        return x
        })
    }
    
    music = song
//    music = soloLoop
    
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }
  
  override func viewDidLoad()  {
    super.viewDidLoad()
    
    self.textView.text = scoreText
  }
  
  @IBAction func playMusic() {
    PLMusicPlayer.sharedInstance.playMusic(music, maxNumberOfTimers: 4)
  }
}

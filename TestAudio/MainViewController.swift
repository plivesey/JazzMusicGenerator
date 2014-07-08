//
//  MainViewController.swift
//  TestAudio
//
//  Created by Peter Livesey on 6/29/14.
//  Copyright (c) 2014 Peter Livesey. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
  
  let music: PLMusicPlayerNote[]
  let scoreText: String
  
  @IBOutlet var textView: UITextView
  
  init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
    
    var chords = generateRandomChords()
    // Let's finish on I
    chords.append(chords[0])
    
    let melody = JazzMelodyGenerator.generateMelodyMeasures(chordMeasures: chords)
    
    let bassline = BasslineGenerator.generateBasslineForChordMeasures(chords)
    
    let rhythm = RhythmSectionGenerator.rhythmSectionFromChords(chords)
    
    for measure in rhythm {
      println("New measure")
      for chord in measure.notes {
        println("B: \(chord.beats) R: \(chord.notes.count == 0)")
      }
    }
    
    scoreText = ""
    for i in 0..chords.count {
      
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
    
    music = createScore(chords: rhythm, melody: melody, bassline: bassline, secondsPerBeat: 0.5)
    
    for note in music {
      println("S: \(note.start) P: \(note.note)")
    }
    
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

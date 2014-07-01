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
    
//    let melody = JazzMelodyGenerator.generateMelodyMeasures(chordMeasures: chords)
    
    let melody = BasslineGenerator.generateBasslineForChordMeasures(chords, transpose: 36)
    
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
    
    music = createScore(chords, melody: melody, secondsPerBeat: 0.3)
    
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

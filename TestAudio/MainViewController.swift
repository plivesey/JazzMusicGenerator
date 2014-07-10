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
    
    let chords = generateRandomChords(numMeasures: 8)
    let melody = JazzMelodyGenerator.generateMelodyMeasures(chordMeasures: chords, solo: false)
    let bassline = BasslineGenerator.generateBasslineForChordMeasures(chords)
    let rhythm = RhythmSectionGenerator.rhythmSectionFromChords(chords)
    let drums = DrumGenerator.generateDrums(numberOfMeasures: chords.count)
    
    let soloChords = generateRandomChords(numMeasures: 16)
    let soloMelody = JazzMelodyGenerator.generateMelodyMeasures(chordMeasures: soloChords, solo: true)
    let soloBassline = BasslineGenerator.generateBasslineForChordMeasures(soloChords)
    let soloRhythm = RhythmSectionGenerator.rhythmSectionFromChords(soloChords)
    let soloDrums = DrumGenerator.generateDrums(numberOfMeasures: soloChords.count)
    
    let endChord = chords[0]
    let endMelody = [MelodyMeasure(notes: [(melody[0].notes[0].note, 4)])]
    let endBassline = [MelodyMeasure(notes: [(bassline[0].notes[0].note, 4)])]
    let endRhythm = [ChordNoteMeasure(notes: [ChordNote(notes: [bassline[0].notes[0].note], beats: 4)])]
    let endDrums = [ChordNoteMeasure(notes: [ChordNote(notes: [52], beats: 4)])]
    
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
    
    let main = createScore(chords: rhythm, melody: melody, bassline: bassline, drums: drums, secondsPerBeat: 0.5)
    let solo = createScore(chords: soloRhythm, melody: soloMelody, bassline: soloBassline, drums: soloDrums, secondsPerBeat: 0.5)
    let end = createScore(chords: endRhythm, melody: endMelody, bassline: endBassline, drums: endDrums, secondsPerBeat: 0.5)
    
    let sectionLength: Float = 0.5 * 4 * 8
    
    var song: PLMusicPlayerNote[] = []
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
    
    music = song
    
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

//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Ian Gristock on 11/08/2015.
//  Copyright (c) 2015 Ian Gristock. All rights reserved.
//

import UIKit
import AVFoundation
class PlaySoundsViewController: UIViewController {
    
    var audioPlayer: AVAudioPlayer!
    var receivedAudio: RecordedAudio!
    var audioEngine: AVAudioEngine!
    var audioFile: AVAudioFile!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayer.enableRate = true
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func playChipmunkAudio(sender: UIButton) {
       playAudioWithVariablePitch(1000)
    }
    
    @IBAction func playDarthVadarAudio(sender: UIButton) {
        playAudioWithVariablePitch(-1000)
    }
    
    
    @IBAction func playEchoAudio(sender: UIButton) {
        
        resetAudio()
        var echoNode = AVAudioUnitDelay()
        echoNode.delayTime = NSTimeInterval(0.4)
        playAudioEffect(echoNode)
    }
    
    @IBAction func playReverbAudio(sender: UIButton) {
        
        resetAudio()
        var reverbNode = AVAudioUnitReverb()
        reverbNode.loadFactoryPreset( AVAudioUnitReverbPreset.LargeHall)
        reverbNode.wetDryMix = 50
        playAudioEffect(reverbNode)
    }
    
    // helper function to handle audio effects ( echo and reverb ) 
    func playAudioEffect(effect: AVAudioUnitEffect) {
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        audioEngine.attachNode(effect)
        audioEngine.connect(audioPlayerNode, to: effect, format: nil)
        audioEngine.connect(effect, to: audioEngine.outputNode, format: nil)
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler:nil)
        audioEngine.startAndReturnError(nil)
        audioPlayerNode.play()
    }
    
    // helper function to handle pitch based effects
    func playAudioWithVariablePitch(pitch: Float){
        
        resetAudio()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
        
    }
    
    @IBAction func stopPlayback(sender: AnyObject) {
        resetAudio()
    }
    
    @IBAction func playSlowAudio(sender: UIButton) {
        resetAudio()
        playAudioBySpeed(0.5)
    }
    
    @IBAction func playFastAudio(sender: UIButton) {
        resetAudio()
        playAudioBySpeed(1.5)
    }
    
    
    func playAudioBySpeed(speed: Float) {
        audioPlayer.stop()
        audioPlayer.rate = speed
        audioPlayer.currentTime = 0.0
        audioPlayer.play()

    }
    
    func resetAudio() {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
}

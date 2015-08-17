//
//  ViewController.swift
//  Pitch Perfect
//
//  Created by Ian Gristock on 11/08/2015.
//  Copyright (c) 2015 Ian Gristock. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController {

    
    @IBOutlet weak var recordingInProgress: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var resumeButton: UIButton!
    
    var audioRecorder : AVAudioRecorder!
    var recordedAudio : RecordedAudio!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        stopButton.hidden = true;
        recordButton.enabled = true
        resumeButton.hidden = true
        pauseButton.hidden = true
        pauseButton.enabled = true
        resumeButton.enabled = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func recordAudio(sender: UIButton) {
        
        recordButton.enabled = false;
        stopButton.hidden = false;
        
        //have hidden the buttons using storyboard by default
        resumeButton.hidden = false
        pauseButton.hidden = false;
        
        recordingInProgress.text = "Recording...";
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        
        
        // using the same file to write over to save space
        let recordingName = "my_audio.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        
        
        //bug found on iphone 6 plus 
        //src: https://discussions.udacity.com/t/extremely-low-volume-when-playing-the-recording-on-my-iphone-6-plus/22061
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self;
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
    }
    
    @IBAction func stopAudio(sender: UIButton) {
        
        recordingInProgress.text = "Tap to record";
        stopButton.hidden = true;
        recordButton.enabled = true;
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance();
        audioSession.setActive(false, error: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "stopRecording" ) {
            let playSoundVC:PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundVC.receivedAudio = data
        }
    }
    

    @IBAction func resumeAudio(sender: UIButton) {
        
        recordingInProgress.text = "Recording..."
        resumeButton.enabled = false;
        pauseButton.enabled = true
        audioRecorder.record();
    }
    
    
    @IBAction func pauseAudio(sender: UIButton) {
        
        recordingInProgress.text = "Paused"
        resumeButton.enabled = true;
        pauseButton.enabled = false
        audioRecorder.pause();
    }
    
}

//MARK : -AVAudioRecorderDelegate
//moving delegate into extension as to not polute the main class, easier to read
extension RecordSoundsViewController : AVAudioRecorderDelegate {
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        
        if(flag){
            var session = AVAudioSession.sharedInstance()
            session.setCategory(AVAudioSessionCategoryPlayback, error: nil)
            recordedAudio = RecordedAudio(filePathUrl: recorder.url, title: recorder.url.lastPathComponent!)
            //have hidden the buttons using storyboard by default
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        }
    }
    
}
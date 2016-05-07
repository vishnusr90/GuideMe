//
//  BeepSound.swift
//  GuideMe
//
//  Created by Vishnu S R on 6/5/16.
//  Copyright © 2016 ISS. All rights reserved.
//

import Foundation
import AVFoundation

class BeepSound {
    
    static var beepInstance : BeepSound?
    
    var audioPlayer:AVAudioPlayer!
    
    static func getInstance() -> BeepSound {
        if (beepInstance == nil){
            beepInstance = BeepSound()
        }
        return beepInstance!
    }
    
    func playBeep() {
        
        do {
            if let bundle = NSBundle.mainBundle().pathForResource("notify", ofType: "mp3") {
                let alertSound = NSURL(fileURLWithPath: bundle)
                try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
                try AVAudioSession.sharedInstance().setActive(true)
                try audioPlayer = AVAudioPlayer(contentsOfURL: alertSound)
                audioPlayer.prepareToPlay()
                audioPlayer.play()
            }
        } catch {
            print("Error")
        }
        
    }
    
    
    
    
}
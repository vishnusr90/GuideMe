//
//  ViewController.swift
//  FirstScreen
//
//  Created by student on 3/5/16.
//  Copyright © 2016 Vishnu S R. All rights reserved.
//

import UIKit
import AVFoundation
import CoreBluetooth
import AudioToolbox

class ViewController: UIViewController, CBCentralManagerDelegate {

    var synthesizer = AVSpeechSynthesizer()
    var myUtterance = AVSpeechUtterance(string: "")
    var centralManager : CBCentralManager!
    static var introMessageCount = 0
    
    @IBAction func startNavigating(sender: AnyObject) {
        
        synthesizer.stopSpeakingAtBoundary(AVSpeechBoundary.Immediate)
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let nvc : UIViewController = storyBoard.instantiateViewControllerWithIdentifier("newViewController")
        self.presentViewController(nvc, animated: true, completion: nil)
        
    }
    
    
    @IBAction func enterSetup(sender: AnyObject) {
        
        synthesizer.stopSpeakingAtBoundary(AVSpeechBoundary.Immediate)
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let nvc : UIViewController = storyBoard.instantiateViewControllerWithIdentifier("setupViewController")
        self.presentViewController(nvc, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        centralManager = CBCentralManager(delegate: self, queue: nil)
        
        if(ViewController.introMessageCount == 0){
            playIntroductoryMessage()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    /* Play the introductory message */
    func playIntroductoryMessage() {
        
            BeepSound.getInstance().playBeep()
            sleep(1)
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            sleep(1)
            let voiceMessage : String = "Hi, Welcome to GuideMe navigation app. Your screen has only two buttons. Press the top button to start navigating or the bottom one to setup "
            synthesizer  = TextToVoice.getInstance().textToVoice(voiceMessage)
            ViewController.introMessageCount += 1
    
    }

    func centralManagerDidUpdateState(central: CBCentralManager) {
        
        if central.state != CBCentralManagerState.PoweredOn {
            bluetoothMessage()
        }
    }
    
    func bluetoothMessage() {
        
        let message = "Please switch on your bluetooth"
        TextToVoice.getInstance().textToVoice(message)
    }

}


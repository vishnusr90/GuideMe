//
//  ViewController.swift
//  FirstScreen
//
//  Created by student on 3/5/16.
//  Copyright © 2016 Vishnu S R. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    let synth = AVSpeechSynthesizer()
    var myUtterance = AVSpeechUtterance(string: "")
    
    @IBAction func startNavigating(sender: AnyObject) {
        
      
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let nvc : UINavigationController = storyBoard.instantiateViewControllerWithIdentifier("newViewController") as! UINavigationController
        self.presentViewController(nvc, animated: true, completion: nil)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // playIntroductoryMessage()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    func playIntroductoryMessage() {
        
        var voiceMessage : String = "Hi, Welcome to GuideMe. Your screen has only two buttons. Press the top button to start navigating or the bottom one to setup "
        myUtterance = AVSpeechUtterance(string: voiceMessage)
        myUtterance.rate = 0.4
        synth.speakUtterance(myUtterance)
    }


}


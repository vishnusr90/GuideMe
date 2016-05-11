//
//  SetupViewController.swift
//  GuideMe
//
//  Created by Vishnu S R on 11/5/16.
//  Copyright © 2016 ISS. All rights reserved.
//

import UIKit
import AVFoundation

class SetupViewController: UIViewController {
    
    var synthesizer : AVSpeechSynthesizer = AVSpeechSynthesizer()

    override func viewDidLoad() {
        
        super.viewDidLoad()
 
        var swipeRight = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        self.view.addGestureRecognizer(swipeRight)
        
        playDirectionMessage()
        // Do any additional setup after loading the view.
    }

    @IBAction func setUpBrightness(sender: AnyObject) {
        
        self.synthesizer.stopSpeakingAtBoundary(AVSpeechBoundary.Immediate)
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let nvc : UIViewController = storyBoard.instantiateViewControllerWithIdentifier("displayViewController")
        self.presentViewController(nvc, animated: true, completion: nil)
    }
    
    @IBAction func setupContact(sender: AnyObject) {
        
        self.synthesizer.stopSpeakingAtBoundary(AVSpeechBoundary.Immediate)
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let nvc : UIViewController = storyBoard.instantiateViewControllerWithIdentifier("smsViewController")
        self.presentViewController(nvc, animated: true, completion: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            switch swipeGesture.direction {
                
            case UISwipeGestureRecognizerDirection.Right:
                self.synthesizer.stopSpeakingAtBoundary(AVSpeechBoundary.Immediate)
                self.performSegueWithIdentifier("mainScreen", sender: self)
            default:
                break
            }
        }
    }
    
    func playDirectionMessage() {
        
        let message = "Press the top half of screen to setup the contact details or the bottom half to adjust the screen brightness"
        self.synthesizer = TextToVoice.getInstance().textToVoice(message)

    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

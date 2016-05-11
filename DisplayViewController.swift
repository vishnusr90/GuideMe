//
//  DisplayViewController.swift
//  GuideMe
//
//  Created by student on 11/5/16.
//  Copyright © 2016 ISS. All rights reserved.
//

import UIKit
import CoreImage
import CoreGraphics
import AVFoundation

class DisplayViewController: UIViewController {

    @IBOutlet weak var brightnessSlider: UISlider!
    let synthesizer = AVSpeechSynthesizer()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var swipeRight = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        self.view.addGestureRecognizer(swipeRight)
        
        // Do any additional setup after loading the view.
    }

    @IBAction func changeBrightness(sender: AnyObject) {
        
        let brightness : Float = Float(brightnessSlider.value)
        UIScreen.mainScreen().brightness = CGFloat(brightness)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            switch swipeGesture.direction {
                
            case UISwipeGestureRecognizerDirection.Right:
                synthesizer.stopSpeakingAtBoundary(AVSpeechBoundary.Immediate)
                self.performSegueWithIdentifier("setupScreen", sender: self)
            default:
                break
            }
        }
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

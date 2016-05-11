//
//  BeaconViewController.swift
//  GuideMe
//
//  Created by Vishnu S R on 6/5/16.
//  Copyright © 2016 ISS. All rights reserved.
//

import UIKit
import CoreLocation
import AVFoundation
import AudioToolbox

class BeaconViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var screenImage: UIImageView!
    
    var locationManager : CLLocationManager!
    var previousMinorValue : Int = 0
    let uuid = NSUUID(UUIDString: "9DC6F0DD-663F-405A-8748-382382FF6D9C")
    var location : Location = Location()
    static var directionMessageCount = 0
    var synthesizer = AVSpeechSynthesizer()
    var stopSynthesizer = AVSpeechSynthesizer()
    var myUtterance = AVSpeechUtterance(string: "")
    let beepSound : BeepSound = BeepSound.getInstance()
    var beaconRegion : CLBeaconRegion?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var swipeRight = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        self.view.addGestureRecognizer(swipeRight)
        
        if BeaconViewController.directionMessageCount == 0{
            self.playDirectionMessage()
        }
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        //locationManager.requestWhenInUseAuthorization()

        
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {

        if status == .AuthorizedAlways { // or .AuthorizedWhenInUse   AuthorizedAlways
            
            if CLLocationManager.isMonitoringAvailableForClass(CLBeaconRegion.self) {
                
                if CLLocationManager.isRangingAvailable() {
                    scanForDevices()
                }
            }
        }
    }
    
    
    func scanForDevices() {
        
        beaconRegion = CLBeaconRegion(proximityUUID: uuid!, identifier: "MRT")
        //locationManager.startMonitoringForRegion(beaconRegion)
        locationManager.startRangingBeaconsInRegion(beaconRegion!)
    }
    
    
    // Reading beacon's distance
    func locationManager(manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], inRegion region: CLBeaconRegion) {
        
        let beacons = beacons.filter{$0.proximity != CLProximity.Unknown}
        
        if beacons.count > 0 {
            //self.stopSynthesizer.stopSpeakingAtBoundary(AVSpeechBoundary.Immediate)
            let closestBeacon = beacons[0]
            let latestMinorValue = closestBeacon.minor.integerValue
            
            if latestMinorValue != previousMinorValue {
                previousMinorValue = latestMinorValue
                displayImage(closestBeacon.proximity, minorValue: Int32(latestMinorValue))
            }
        }else {
           
            //self.stopSynthesizer = TextToVoice.getInstance().textToVoice("No beacons found in the vicinity")
            beepSound.playError()
            self.stopSynthesizer.stopSpeakingAtBoundary(AVSpeechBoundary.Immediate)
        }
    }
    

    func displayImage(distance: CLProximity, minorValue : Int32) {
        
        let textToVoiceObject = TextToVoice.getInstance()

        UIView.animateWithDuration(0.8) {
            
            self.location = DataBaseTable.getInstance().fetchBeaconData(minorValue)

            switch distance {
                
                case .Near:
                    AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                    self.screenImage.image = UIImage(named: self.location.imageURL as String)
                    self.beepSound.playBeep()
                    sleep(1)
                    self.synthesizer = textToVoiceObject.textToVoice(self.location.voiceMessage)
                
                case .Immediate: break 
            
                default : 
                    break
            }
        }
    }
    
    
    /* Calling contact */
    @IBAction func sendSMS(sender: AnyObject) {
        
        let phone = SmsViewController().retrivePhoneNumber()
        
        if phone != "Nil"{
            var callUrl : NSURL = NSURL(string: "tel://\(phone)")!
            UIApplication.sharedApplication().openURL(callUrl)
        }else{
            
            let message = "Please set up your emergency contact number to place a call"
            TextToVoice.getInstance().textToVoice(message)
        }
 
        
    }
    
    
    
    /* Replay the message */
    @IBAction func replayMessage(sender: AnyObject) {
       
        self.synthesizer.stopSpeakingAtBoundary(AVSpeechBoundary.Immediate)
        
        if self.location.voiceMessage != " " {
            TextToVoice.getInstance().textToVoice(self.location.voiceMessage)

        }
    }
    
    /* Swipe right gesture */
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            switch swipeGesture.direction {
                
                case UISwipeGestureRecognizerDirection.Right:
                    synthesizer.stopSpeakingAtBoundary(AVSpeechBoundary.Immediate)
                    locationManager.stopRangingBeaconsInRegion(beaconRegion!)
                    self.performSegueWithIdentifier("mainScreen", sender: self)
                    self.location.voiceMessage = ""
                default:
                    break
            }
        }
    }
    
    func playDirectionMessage() {
        let message = "To return to main screen , please swipe right"
        TextToVoice.getInstance().textToVoice(message)
        BeaconViewController.directionMessageCount += 1
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
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

class BeaconViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var screenImage: UIImageView!
    
    var locationManager : CLLocationManager!
    var previousMinorValue : Int = 0
    let uuid = NSUUID(UUIDString: "9DC6F0DD-663F-405A-8748-382382FF6D9C")
    var location : Location = Location()
    static var directionMessageCount = 0
    var synthesizer = AVSpeechSynthesizer()
    var myUtterance = AVSpeechUtterance(string: "")
    let beepSound : BeepSound = BeepSound.getInstance()
    
    @IBOutlet weak var status: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.status.text  = "viewDidLoad"
        
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
        
        // Testing
        self.test(10)
        
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        self.status.text  = "location manager"
        if status == .AuthorizedAlways { // or .AuthorizedWhenInUse   AuthorizedAlways
            
            if CLLocationManager.isMonitoringAvailableForClass(CLBeaconRegion.self) {
                
                if CLLocationManager.isRangingAvailable() {
                    scanForDevices()
                }
            }
        }
    }
    
    
    func scanForDevices() {
        
        let beaconRegion = CLBeaconRegion(proximityUUID: uuid!, identifier: "hello")
        locationManager.startMonitoringForRegion(beaconRegion)
        locationManager.startRangingBeaconsInRegion(beaconRegion)

    }
    
    
    // Reading beacon's distance
    func locationManager(manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], inRegion region: CLBeaconRegion) {
        
        let beacons = beacons.filter{$0.proximity != CLProximity.Unknown}
         self.status.text  = String(beacons.count)
        if beacons.count > 0 {
            let closestBeacon = beacons[0]
            let latestMinorValue = closestBeacon.minor.integerValue
            
            if latestMinorValue != previousMinorValue {
                previousMinorValue = latestMinorValue
               // displayImage(closestBeacon.proximity, minorValue: Int32(latestMinorValue))
            }
        }else {
           
            beepSound.playBeep()
            sleep(1)
            TextToVoice.getInstance().textToVoice("No beacons found in the vicinity")
        }
    }
    
    
    func test(minorValue : Int32){
    //func displayImage(distance: CLProximity, minorValue : Int32) {
        
        self.status.text  = "Display"
        let textToVoiceObject = TextToVoice.getInstance()
        
        let distance : CLProximity = .Near
        UIView.animateWithDuration(0.8) {
            
            self.location = DataBaseTable.getInstance().fetchBeaconData(minorValue)

            switch distance {
                
                case .Near:
                    self.status.text  = "Reached"
                    self.screenImage.image = UIImage(named: self.location.imageURL as String)
                    self.beepSound.playBeep()
                    sleep(1)
                    self.synthesizer = textToVoiceObject.textToVoice(self.location.voiceMessage)
                
                case .Immediate: break //print("Immediate")
            
                default : print("Default !")
                    break
            }
        }
    }
    
    
    /* Sending sms */
    @IBAction func sendSMS(sender: AnyObject) {
        
        let phone = SmsViewController().retrivePhoneNumber()
        print("Calling\(phone)")
//      let phone = "84290757"
        var callUrl : NSURL = NSURL(string: "tel://\(phone)")!
        UIApplication.sharedApplication().openURL(callUrl)
    }
    
    
    
    /* Replay the message */
    @IBAction func replayMessage(sender: AnyObject) {
       
        self.synthesizer.stopSpeakingAtBoundary(AVSpeechBoundary.Immediate)
        TextToVoice.getInstance().textToVoice(self.location.voiceMessage)
        
    }
    
    
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            switch swipeGesture.direction {
                
                case UISwipeGestureRecognizerDirection.Right:
                    synthesizer.stopSpeakingAtBoundary(AVSpeechBoundary.Immediate)
                    self.performSegueWithIdentifier("mainScreen", sender: self)
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
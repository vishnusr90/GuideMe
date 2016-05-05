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

    var voiceMessage: String = ""
    var tempMessage: String!
    var previousMinorValue : Int = 0
    
    let synth = AVSpeechSynthesizer()
    var myUtterance = AVSpeechUtterance(string: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        //locationManager.requestWhenInUseAuthorization()
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        if status == .AuthorizedAlways { // or .AuthorizedWhenInUse
            
            if CLLocationManager.isMonitoringAvailableForClass(CLBeaconRegion.self) {
                
                if CLLocationManager.isRangingAvailable() {
                    scanForDevices()
                    
                }
            }
        }
    }
    
    func scanForDevices() {
        
        let uuid = NSUUID(UUIDString: "7F35411E-6E82-43BC-A6EE-B6BBB472790D")
        let beaconRegion = CLBeaconRegion(proximityUUID: uuid!, major: 15 , minor: 10, identifier: "hello")
        
        locationManager.startMonitoringForRegion(beaconRegion)
        locationManager.startRangingBeaconsInRegion(beaconRegion)
        
    }
    
    // Reading beacon's distance
    func locationManager(manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], inRegion region: CLBeaconRegion) {
        
        print("")
        let beacons = beacons.filter{$0.proximity != CLProximity.Unknown}
       
        if beacons.count > 0 {
            let closestBeacon = beacons[0]
            let latestMinorValue = closestBeacon.minor.integerValue
            
            if latestMinorValue != previousMinorValue {
                
                previousMinorValue = latestMinorValue
                displayImage(closestBeacon.proximity, minorValue: latestMinorValue)
            }
        }else {
            print("No beacons found !")
        }
    }
    
    // ***  call the replay button in different function
    
    func displayImage(distance: CLProximity, minorValue : Int) {
       
        // accessing the image from folder    -  image.png
        //                let imageURL = NSBundle.mainBundle().URLForResource("image", withExtension: "png")
        //                let image = UIImage(contentsOfFile: imageURL!.path!)
        
        UIView.animateWithDuration(0.8) {
            
            switch distance {
                
            case .Near: print("Near !")
            
            if minorValue == 10 {
                
                self.view.backgroundColor = UIColor.orangeColor()
                self.screenImage.image = UIImage(named: "entrance.png")
                self.voiceMessage =  "You have reached the entrance ! "
                self.speak(self.voiceMessage)
                
            }else if minorValue == 15 {
                
                
                self.view.backgroundColor = UIColor.orangeColor()
                self.screenImage.image = UIImage(named: "elevator.png")
                self.voiceMessage =  "Elevator ! "
                self.speak(self.voiceMessage)
                }
                
                
                
            case .Immediate: print("Immediate")
            
            self.view.backgroundColor = UIColor.cyanColor()
            
            self.voiceMessage =  "you are immediate"
            self.speak(self.voiceMessage)
                
                //
                //            case .Far:
                //                self.view.backgroundColor = UIColor.blueColor()
                //                self.textMessage.text = "You are very far, please come near"
            //
            default : print("Default !")
            self.screenImage.image = nil
            self.voiceMessage = "you are out of range"
            }
        }
        // self.speak(textMessage.text)
    }
    
    func speak(voiceMessage : String) {
        myUtterance = AVSpeechUtterance(string: voiceMessage)
        myUtterance.rate = 0.3
        synth.speakUtterance(myUtterance)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func sendSMS(sender: AnyObject) {
        
    }
    
    
    @IBAction func replayMessage(sender: AnyObject) {
        
        self.speak(self.voiceMessage)
        
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

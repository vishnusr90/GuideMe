//
//  BeaconViewController.swift
//  GuideMe
//
//  Created by Vishnu S R on 6/5/16.
//  Copyright © 2016 ISS. All rights reserved.
//

import UIKit
import CoreLocation
import CoreBluetooth
import AVFoundation

class BeaconViewController: UIViewController, CLLocationManagerDelegate, CBPeripheralManagerDelegate {

    @IBOutlet weak var screenImage: UIImageView!
    
    var locationManager : CLLocationManager!
    
    var previousMinorValue : Int = 0
    let uuid = NSUUID(UUIDString: "7F35411E-6E82-43BC-A6EE-B6BBB472790D")
    var location : Location = Location()
    
    let synthesizer = AVSpeechSynthesizer()
    var myUtterance = AVSpeechUtterance(string: "")
    let beepSound : BeepSound = BeepSound.getInstance()
    var bluetoothPeripheralManager: CBPeripheralManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.textToVoice("Shiva")
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        //locationManager.requestWhenInUseAuthorization()
        
        // Testing
        self.test(10)
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        if status == .AuthorizedWhenInUse { // or .AuthorizedWhenInUse   AuthorizedAlways
            
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
        
        if beacons.count > 0 {
            let closestBeacon = beacons[0]
            let latestMinorValue = closestBeacon.minor.integerValue
            
            if latestMinorValue != previousMinorValue {
                previousMinorValue = latestMinorValue
                
                
                //  displayImage(closestBeacon.proximity, minorValue: latestMinorValue)
            }
        }else {
            print("No beacons found !")
            beepSound.playBeep()
            sleep(1)
            TextToVoice.getInstance().textToVoice("No beacons found in the vicinity")
        }
    }
    
    // ***  call the replay button in different function
    
    func test(minorValue : Int32){
        //func displayImage(distance: CLProximity, minorValue : Int) {
        
        // accessing the image from folder    -  image.png
        //                let imageURL = NSBundle.mainBundle().URLForResource("image", withExtension: "png")
        //                let image = UIImage(contentsOfFile: imageURL!.path!)
        
        let textToVoice : TextToVoice = TextToVoice()
        
        let distance : CLProximity = .Near
        UIView.animateWithDuration(0.8) {
            
            self.location = DataBaseTable.getInstance().fetchBeaconData(minorValue)
            
            
            switch distance {
                
            case .Near:
                
                
                if minorValue == 10 {
                    
                    print(self.location.imageURL)
                    //let imageURL = NSBundle.mainBundle().URLForResource(self.location.imageURL, withExtension: "png")
                    //print("Image url " + (imageURL?.absoluteString)!)
                    //self.screenImage.image = UIImage(contentsOfFile: imageURL!.path!)
                    self.beepSound.playBeep()
                    sleep(1)
                    print("Location msg " + self.location.voiceMessage)
                    TextToVoice.getInstance().textToVoice(self.location.voiceMessage)
                    
                }else if minorValue == 15 {
                    
                    
                    self.screenImage.image = UIImage(named: "elevator.png")
                    //           self.voiceMessage =  "Elevator ! "
                    //           self.speak(self.voiceMessage)
                }
                
            case .Immediate: print("Immediate")
            
            self.view.backgroundColor = UIColor.cyanColor()
                
                //           self.voiceMessage =  "you are immediate"
                //           self.speak(self.voiceMessage)
                
                
                //
                //            case .Far:
                //                self.view.backgroundColor = UIColor.blueColor()
                //                self.textMessage.text = "You are very far, please come near"
            //
            default : print("Default !")
                
            }
            
            
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /* Sending sms */
    @IBAction func sendSMS(sender: AnyObject) {
        print("Sending sms")
    }
    
    
    /* Replay the message */
    @IBAction func replayMessage(sender: AnyObject) {
        
        print("Replaying message")
        TextToVoice.getInstance().textToVoice(self.location.voiceMessage)
        
    }
    
    
    // check if bluetooth is switched on
    
    func peripheralManagerDidUpdateState(peripheral: CBPeripheralManager!) {
        //        var statusMessage = ""
        //
        //        switch peripheral.state {
        //        case CBPeripheralManagerState.PoweredOn:
        //            statusMessage = "Bluetooth Status: Turned On"
        //
        //        case CBPeripheralManagerState.PoweredOff:
        //            if isBroadcasting {
        //                switchBroadcastingState(self)
        //            }
        //            statusMessage = "Bluetooth Status: Turned Off"
        //
        //        case CBPeripheralManagerState.Resetting:
        //            statusMessage = "Bluetooth Status: Resetting"
        //
        //        case CBPeripheralManagerState.Unauthorized:
        //            statusMessage = "Bluetooth Status: Not Authorized"
        //
        //        case CBPeripheralManagerState.Unsupported:
        //            statusMessage = "Bluetooth Status: Not Supported"
        //
        //        default:
        //            statusMessage = "Bluetooth Status: Unknown"
        //        }
        //
        //        lblBTStatus.text = statusMessage
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

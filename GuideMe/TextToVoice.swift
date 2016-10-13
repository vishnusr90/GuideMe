//
//  TextToVoice.swift
//  GuideMe
//
//  Created by Vishnu S R on 7/5/16.
//  Copyright © 2016 ISS. All rights reserved.
//

import Foundation
import AVFoundation


class TextToVoice {
    
    let synthesizer = AVSpeechSynthesizer()
    var myUtterance = AVSpeechUtterance(string: "")
    static var instance : TextToVoice?
    
    init() {
        
    }
    
    static func getInstance() -> TextToVoice {
        
        if(instance == nil) {
            instance = TextToVoice()
        }
        return instance!
    }
    
    func textToVoice(textMessage : String) -> AVSpeechSynthesizer {
        
        myUtterance = AVSpeechUtterance(string: textMessage)
        myUtterance.rate = 0.4
        synthesizer.speakUtterance(myUtterance)
        return synthesizer
    }
    
    
}
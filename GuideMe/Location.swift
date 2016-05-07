//
//  Location.swift
//  GuideMe
//
//  Created by student on 6/5/16.
//  Copyright © 2016 ISS. All rights reserved.
//

import Foundation

class Location {
    
    var voiceMessage : String = ""
    var imageURL : String = ""
    var location : String = ""
    
    init(){
        
    }
    
    init(voiceMessage : String, image : String, location : String) {
        
        self.voiceMessage = voiceMessage
        self.imageURL = image
        self.location = location
    }
}

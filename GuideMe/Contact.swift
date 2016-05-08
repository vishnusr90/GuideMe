//
//  Contact.swift
//  GuideMe
//
//  Created by student on 9/5/16.
//  Copyright © 2016 ISS. All rights reserved.
//

import Foundation


class Contact {
    
    var name :String?
    var phoneNumber :String?
    var status : String?
    
    init() {
        
    }
    
    init(name :String , phoneNumber : String) {
        
        self.name = name
        self.phoneNumber = phoneNumber
    }
}
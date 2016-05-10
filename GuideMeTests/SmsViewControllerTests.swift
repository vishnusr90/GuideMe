//
//  SmsViewControllerTests.swift
//  GuideMe
//
//  Created by student on 10/5/16.
//  Copyright © 2016 ISS. All rights reserved.
//

import Foundation
import XCTest

class SmsViewControllerTests: XCTestCase {
  
//    var vc : SmsViewController!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        vc = storyBoard.instantiateViewControllerWithIdentifier("smsViewController")
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testCreateContact(){
        
        let name = "Ankan"
        let phone = "85265645"
        
        
        
        
    }
    
    
}

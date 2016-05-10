//
//  GuideMeTests.swift
//  GuideMeTests
//
//  Created by student on 4/5/16.
//  Copyright © 2016 ISS. All rights reserved.
//

import XCTest
@testable import GuideMe

class GuideMeTests: XCTestCase {
    
    var vc : SmsViewController = SmsViewController()

    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        vc = storyboard.instantiateViewControllerWithIdentifier("smsViewController") as! SmsViewController
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
    
    func testCreateContact() {
        let nameStr = "Ankan"
        let phoneStr = "84522123"
        var contact : Contact = Contact()
        contact = ContactsDataBaseTable.getInstance().createContact(nameStr, phone: phoneStr)
        XCTAssertEqual(contact.name, nameStr)
        XCTAssertEqual(contact.phoneNumber, phoneStr)
    }
    
    func testNegativeTestCreateContact() {
        let nameStr = "Ankan"
        let phoneStr = "84522123"
        var contact : Contact = Contact()
        contact = ContactsDataBaseTable.getInstance().createContact(nameStr, phone: phoneStr)
        let testName = "Mohan"
        let testPhone = "77777777"
        XCTAssertNotEqual(contact.name, testName)
        XCTAssertNotEqual(contact.phoneNumber, testPhone)
    }
    
    func testUpdateContact() {
    
        let nameStr = "Vishnu"
        let phoneStr = "78999123"
        var contact : Contact = Contact()
        contact = ContactsDataBaseTable.getInstance().updateContact(nameStr, phone: phoneStr)
        XCTAssertEqual(contact.name, nameStr)
        XCTAssertEqual(contact.phoneNumber, phoneStr)

    }
    
    func testNegativetestUpdateContact() {
        
        let nameStr = "Vishnu"
        let phoneStr = "78999123"
        var contact : Contact = Contact()
        contact = ContactsDataBaseTable.getInstance().updateContact(nameStr, phone: phoneStr)
        let testName = "Mohan"
        let testPhone = "77799"
        XCTAssertNotEqual(contact.name, testName)
        XCTAssertNotEqual(contact.phoneNumber, testPhone)
        
    }
    
    func testDeleteContact() {
        
        let nameStr = "Ankan"
        let phoneStr = "77411111"
        var contact : Contact = Contact()
        contact = ContactsDataBaseTable.getInstance().deleteContact(nameStr, phone: phoneStr)
    
        XCTAssertNil(contact.name, "Contact name deleted")
        XCTAssertNil(contact.phoneNumber, "Contact number deleted")
        
        
    }
    
    
    
    
}

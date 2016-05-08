//
//  SmsViewController.swift
//  GuideMe
//
//  Created by student on 7/5/16.
//  Copyright © 2016 ISS. All rights reserved.
//

import Foundation
import UIKit

class SmsViewController: UIViewController,UITableViewDataSource,UITableViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var scrollPage: UIScrollView!
    
    var contactList : NSMutableArray!
    var phoneList : NSMutableArray!
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var status: UILabel!
    
    var contactDB : COpaquePointer = nil;
    var insertStatement : COpaquePointer = nil;
    var selectStatement : COpaquePointer = nil;
    var updateStatement : COpaquePointer = nil;
    var deleteStatement : COpaquePointer = nil;
    
    let SQLITE_TRANSIENT = unsafeBitCast(-1, sqlite3_destructor_type.self)
    
    override func viewDidLoad() {
 
        scrollPage.contentSize.height = 700
        contactList = NSMutableArray()
        phoneList = NSMutableArray()
        
        var swipeRight = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        self.view.addGestureRecognizer(swipeRight)
        
        name.delegate = self
        phone.delegate = self
        
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) [0] as String
        
        print(paths)
        
        let docsDir = paths + "/contacts.sqlite"
        
        if(sqlite3_open(docsDir, &contactDB) == SQLITE_OK)
        {
            let sql = "CREATE TABLE IF NOT EXISTS CONTACTS (ID INTEGER PRIMARY KEY AUTOINCREMENT, NAME TEXT,PHONE TEXT)"
            
            
            if(sqlite3_exec(contactDB,sql,nil,nil,nil)  !=  SQLITE_OK){
                print("Failed to create table")
                print(sqlite3_errmsg(contactDB));
                
            }
        }
        else {
            
            print("Failed to open database")
            print(sqlite3_errmsg(contactDB));
            
        }
        
        prepareStartment();
        
        tableView.delegate = self
        tableView.dataSource = self
        loadContact()
        
    }
    
    
    func prepareStartment() {
        var sqlString : String
        sqlString = "INSERT INTO CONTACTS (name,phone) VALUES (?,?)"
        var cSql = sqlString.cStringUsingEncoding(NSUTF8StringEncoding)
        sqlite3_prepare_v2(contactDB,cSql!,-1,&insertStatement,nil)
        
        
        
//        sqlString = "SELECT phone FROM contacts WHERE name=?"
//        cSql = sqlString.cStringUsingEncoding(NSUTF8StringEncoding)
//        sqlite3_prepare_v2(contactDB,cSql!,-1,&selectStatement,nil)
       
        
        sqlString = "UPDATE CONTACTS SET phone=? WHERE name = ?"
        cSql = sqlString.cStringUsingEncoding(NSUTF8StringEncoding)
        sqlite3_prepare_v2(contactDB,cSql!,-1,&updateStatement,nil)
        
        
        
        sqlString = "DELETE FROM CONTACTS WHERE name = ?"
        cSql = sqlString.cStringUsingEncoding(NSUTF8StringEncoding)
        sqlite3_prepare_v2(contactDB,cSql!,-1,&deleteStatement,nil)
        
        
        sqlString = "SELECT * FROM CONTACTS"
        cSql = sqlString.cStringUsingEncoding(NSUTF8StringEncoding)
        sqlite3_prepare_v2(contactDB,cSql!,-1,&selectStatement,nil)
        

    }
    
    @IBAction func createContact(sender: AnyObject) {
        
        
        
        let nameStr = name.text as NSString?
        
        let phoneStr = phone.text as NSString?
        
        
        sqlite3_bind_text(insertStatement, 1, nameStr!.UTF8String, -1, SQLITE_TRANSIENT);
    
        sqlite3_bind_text(insertStatement, 2, phoneStr!.UTF8String, -1, SQLITE_TRANSIENT);
        
        
        if(sqlite3_step(insertStatement) == SQLITE_DONE)
        {
            status.text = "Contact added";
            contactList?.addObject(nameStr!)
            phoneList?.addObject(phoneStr!)
//            print(phoneList)
        }
            
        else {
            
            status.text = "Failed to add contact";
            print("Error Code: ", sqlite3_errcode (contactDB));
            let error = String.fromCString(sqlite3_errmsg(contactDB));
            print("Error msg: ",error);
        }
        sqlite3_reset(insertStatement);
        sqlite3_clear_bindings(insertStatement);
        tableView.reloadData()
        
        
        
    }
//    @IBAction func findContact(sender: AnyObject) {
//        
//        let nameStr = name.text as NSString?
//        sqlite3_bind_text(selectStatement, 1, nameStr!.UTF8String, -1, SQLITE_TRANSIENT);
//        
//        if(sqlite3_step(selectStatement) == SQLITE_ROW){
//            status.text = "Record retrieved";
//           
//            
//            let phone_buf = sqlite3_column_text(selectStatement, 1)
//            phone.text = String.fromCString(UnsafePointer<CChar>(phone_buf))
//        }
//        else {
//            status.text = "Failed to retrive contact";
//            
//            phone.text = " ";
//            print("Error code: ",sqlite3_errcode(contactDB));
//            let error = String.fromCString(sqlite3_errmsg(contactDB));
//            print("Error msg: ", error);
//        }
//        
//        sqlite3_reset(selectStatement);
//        sqlite3_clear_bindings(selectStatement);
//        
//        
//    }
    
    @IBAction func updateContact(sender: AnyObject) {
        let nameStr = name.text as NSString?
        
        let phoneStr = phone.text as NSString?
        
      
        sqlite3_bind_text(updateStatement, 1, phoneStr!.UTF8String, -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(updateStatement, 2, nameStr!.UTF8String, -1, SQLITE_TRANSIENT);
        
        
        if(sqlite3_step(updateStatement) == SQLITE_DONE)
        {
            status.text = "Contact updated";
            phoneList?.removeLastObject()
            phoneList?.addObject(phoneStr!)

        }
            
        else {
            
            status.text = "Failed to update contact";
            print("Error Code: ", sqlite3_errcode (contactDB));
            let error = String.fromCString(sqlite3_errmsg(contactDB));
            print("Error msg: ",error);
        }
        sqlite3_reset(updateStatement);
        sqlite3_clear_bindings(updateStatement);
        tableView.reloadData()
        
    }
    
    @IBAction func deleteContact(sender: AnyObject) {
        let nameStr = name.text as NSString?
        let phoneStr = phone.text as NSString?
        sqlite3_bind_text(deleteStatement, 1, nameStr!.UTF8String, -1, SQLITE_TRANSIENT);
        
        
        if(sqlite3_step(deleteStatement) == SQLITE_DONE){
            status.text = "Contact deleted";
            contactList?.removeObject(nameStr!)
            phoneList?.removeObject(phoneStr!)

        }
        else {
            status.text = "Failed to delete contact";
            print("Error code: ",sqlite3_errcode(contactDB));
            let error = String.fromCString(sqlite3_errmsg(contactDB));
            print("Error msg: ", error);
        }
        
        sqlite3_reset(deleteStatement);
        sqlite3_clear_bindings(deleteStatement);
        tableView.reloadData()
        
        
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        let contact = contactList[indexPath.row] as! String
        let phone = phoneList[indexPath.row] as! String
        cell.textLabel?.text = contact
        cell.detailTextLabel?.text = phone
        return cell
    }
    
    
    func loadContact(){
        print("being fetched")
        while(sqlite3_step(selectStatement) == SQLITE_ROW)
        {
            
            let contact_buf = String.fromCString(UnsafePointer<CChar>(sqlite3_column_text(selectStatement, 1)))
            let phn_buf = String.fromCString(UnsafePointer<CChar>(sqlite3_column_text(selectStatement, 2)))
            
            if(contact_buf != nil && phn_buf != nil){
                contactList.addObject(contact_buf!)
                phoneList.addObject(phn_buf!)
                print("values fetched: \(String(contact_buf)) \(String(phn_buf))")
            }
        }
        sqlite3_reset(selectStatement)
        sqlite3_clear_bindings(selectStatement)
        tableView.reloadData()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        name.resignFirstResponder()
        phone.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        name.resignFirstResponder()
        phone.resignFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            switch swipeGesture.direction {
                
            case UISwipeGestureRecognizerDirection.Right:
                self.performSegueWithIdentifier("mainScreen", sender: self)
            default:
                break
            }
        }
    }
    
    @IBAction func returnToMainScreen(sender: AnyObject) {
        
        self.performSegueWithIdentifier("unwindToMainScreen", sender: self)
    }
}



//
//  ContactViewController.swift
//  GuideMe
//
//  Created by Ankan Das on 7/5/16.
//  Copyright © 2016 ISS. All rights reserved.
//

import Foundation
import UIKit

class ContactViewController: UIViewController,UITableViewDataSource,UITableViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var scrollPage: UIScrollView!
    
    var contactList = NSMutableArray()
    var phoneList = NSMutableArray()
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var status: UILabel!
    
    
    @IBOutlet weak var updateOutlet: UIButton!
    @IBOutlet weak var addOutlet: UIButton!
    @IBOutlet weak var deleteOutlet: UIButton!

    
    override func viewDidLoad() {
 
        scrollPage.contentSize.height = 700
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(ContactViewController.respondToSwipeGesture(_:)))
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        self.view.addGestureRecognizer(swipeRight)
        
        name.delegate = self
        phone.delegate = self
        addOutlet.enabled = false
        updateOutlet.enabled = false
        deleteOutlet.enabled = false

        tableView.delegate = self
        tableView.dataSource = self
        viewContact()
        
    }
    
    @IBAction func createContact(sender: AnyObject) {
        
        let nameStr = name.text as NSString?
        let phoneStr = phone.text
        
        if ((name.text == nil && phone.text == nil) || name.text == "" || phone.text == "" || name.text == "Name" || phone.text == "Phone Number"){
            TextToVoice.getInstance().textToVoice("Please enter the name and phone number")
            name.resignFirstResponder()
            phone.resignFirstResponder()
            return
        }
        
        var contact : Contact = Contact()
        
        contact =  ContactsDataBaseTable.getInstance().createContact(nameStr!,phone: phoneStr!)
        contactList.addObject(contact.name!)
        phoneList.addObject(contact.phoneNumber!)
        status.text = contact.status
        
        name.text = nil
        phone.text = nil
        addOutlet.enabled = false
        updateOutlet.enabled = false
        deleteOutlet.enabled = false
        name.resignFirstResponder()
        phone.resignFirstResponder()
        tableView.reloadData()
    
    }
    
    @IBAction func updateContact(sender: AnyObject) {
        
        if ((name.text == nil && phone.text == nil) || name.text == "" || phone.text == "" || name.text == "Name" || phone.text == "Phone Number"){
            TextToVoice.getInstance().textToVoice("Please enter the name and phone number")
            updateOutlet.enabled = false
            name.resignFirstResponder()
            phone.resignFirstResponder()
            return
        }
        let nameStr = name.text as NSString?
        
        let phoneStr = phone.text as NSString?
        

        var contact : Contact = Contact()
        
        contact = ContactsDataBaseTable.getInstance().updateContact(nameStr!, phone: phoneStr!)
      
        status.text = contact.status
        contactList.removeLastObject()
        contactList.addObject(contact.name!)
        phoneList.removeLastObject()
        phoneList.addObject(contact.phoneNumber!)

        name.text = nil
        phone.text = nil
        addOutlet.enabled = false
        updateOutlet.enabled = false
        deleteOutlet.enabled = false
        name.resignFirstResponder()
        phone.resignFirstResponder()
        tableView.reloadData()
        
    }
    
    @IBAction func deleteContact(sender: AnyObject) {
        
        let nameStr = name.text as NSString?
        let phoneStr = phone.text as NSString?

        var contact : Contact = Contact()
        contact = ContactsDataBaseTable.getInstance().deleteContact(nameStr!, phone: phoneStr!)

        status.text = contact.status
        contactList.removeAllObjects()
        phoneList.removeAllObjects()

        addOutlet.enabled = false
        deleteOutlet.enabled = false
        updateOutlet.enabled = false
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
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        let selectName = contactList[indexPath.row] as! String
        let selectPhoneNumber = phoneList[indexPath.row] as! String
        name.text = selectName
        phone.text = selectPhoneNumber
        deleteOutlet.enabled = true
        updateOutlet.enabled = true
        
    }
    
    func viewContact() -> String{

        var contact : Contact = Contact()
        contact = ContactsDataBaseTable.getInstance().loadContact()

        if let name = contact.name {
            if let phone = contact.phoneNumber {
                contactList.addObject(name)
                phoneList.addObject(phone)
            }
        }
        if (phoneList.count > 0) {
            addOutlet?.enabled = false
            deleteOutlet?.enabled = false
            updateOutlet?.enabled = false
            return phoneList[0] as! String
            
        }
        return "Nil"
    }
    
    
    func retrivePhoneNumber() -> String{
        let phoneNumber = viewContact()
        return phoneNumber
    }
        
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        name.resignFirstResponder()
        phone.resignFirstResponder()
        return true
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        
        if (textField.tag == 100){
            TextToVoice.getInstance().textToVoice("Please enter the name")
        }
        
        if (textField.tag == 200){
            TextToVoice.getInstance().textToVoice("Please enter the number")
        }

        if phoneList.count > 0 {
            addOutlet.enabled = false
            
        }else{
            addOutlet.enabled = true
        }

        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
        
        if ((name.text == nil && phone.text == nil) || name.text == "" || phone.text == ""){
           addOutlet.enabled = false
           return
        }

        addOutlet.enabled = true
        if phoneList.count > 0 {
            addOutlet.enabled = false
        }else{
            addOutlet.enabled = true
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            switch swipeGesture.direction {
                
                case UISwipeGestureRecognizerDirection.Right:
                self.performSegueWithIdentifier("setupScreen", sender: self)
                
                default:
                break
            }
        }
    }
}



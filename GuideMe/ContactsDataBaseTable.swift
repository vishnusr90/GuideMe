//
//  ContactsDataBaseTable.swift
//  GuideMe
//
//  Created by student on 9/5/16.
//  Copyright © 2016 ISS. All rights reserved.
//

import Foundation

class ContactsDataBaseTable {
    static var ContactsDataBaseInstance : ContactsDataBaseTable?
    

    
    var contactDB : COpaquePointer = nil;
    
    var insertStatement : COpaquePointer = nil;
    var selectStatement : COpaquePointer = nil;
    var updateStatement : COpaquePointer = nil;
    var deleteStatement : COpaquePointer = nil;
    
    var status : String = ""
    
    let SQLITE_TRANSIENT = unsafeBitCast(-1, sqlite3_destructor_type.self)
    
    
    static func getInstance() -> ContactsDataBaseTable {
        
        if(ContactsDataBaseInstance == nil){
            ContactsDataBaseInstance = ContactsDataBaseTable()
        }
        return ContactsDataBaseInstance!
    }

    
    func createContactTable(){
        
                let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) [0] as String
        
                print(paths)
        
                let docsDir = paths + "/guideME.sqlite"
        
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

        
            }
    func prepareStartment() {
        var sqlString : String
        sqlString = "INSERT INTO CONTACTS (name,phone) VALUES (?,?)"
        var cSql = sqlString.cStringUsingEncoding(NSUTF8StringEncoding)
        sqlite3_prepare_v2(contactDB,cSql!,-1,&insertStatement,nil)
        
        
        sqlString = "UPDATE CONTACTS SET phone=? WHERE name = ?"
        cSql = sqlString.cStringUsingEncoding(NSUTF8StringEncoding)
        sqlite3_prepare_v2(contactDB,cSql!,-1,&updateStatement,nil)
        
        
        
        sqlString = "DELETE FROM CONTACTS"
        cSql = sqlString.cStringUsingEncoding(NSUTF8StringEncoding)
        sqlite3_prepare_v2(contactDB,cSql!,-1,&deleteStatement,nil)
        

        sqlString = "SELECT * FROM CONTACTS"
        cSql = sqlString.cStringUsingEncoding(NSUTF8StringEncoding)
        sqlite3_prepare_v2(contactDB,cSql!,-1,&selectStatement,nil)
        
        
    }
  
    

        
    func createContact(name : NSString, phone : NSString) -> Contact {
        
        let contact : Contact = Contact()
        
        let nameStr = name
        
        let phoneStr = phone
        
        
        sqlite3_bind_text(insertStatement, 1, nameStr.UTF8String, -1, SQLITE_TRANSIENT);
        
        sqlite3_bind_text(insertStatement, 2, phoneStr.UTF8String, -1, SQLITE_TRANSIENT);
        
        
        if(sqlite3_step(insertStatement) == SQLITE_DONE)
        {
            
             contact.name = name as String
             contact.phoneNumber = phone as String
             contact.status = "Contact added"
        }
            
        else {
            
            contact.status = "Failed to add contact";
            print("Error Code: ", sqlite3_errcode (contactDB));
            let error = String.fromCString(sqlite3_errmsg(contactDB));
            print("Error msg: ",error);
        }
        
        sqlite3_reset(insertStatement);
        sqlite3_clear_bindings(insertStatement);

        return contact
        
        
        
    }
    
    func updateContact(name : NSString, phone : NSString) -> Contact{
        
        let contact : Contact = Contact()
        
        let nameStr = name
        
        let phoneStr = phone
        
        
        sqlite3_bind_text(updateStatement, 1, phoneStr.UTF8String, -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(updateStatement, 2, nameStr.UTF8String, -1, SQLITE_TRANSIENT);
        
        
        if(sqlite3_step(updateStatement) == SQLITE_DONE)
        {
            contact.name = name as String
            contact.phoneNumber = phone as String
            contact.status = "Contact Updated"
            
        }
        else {
            
            contact.status = "Failed to update contact";
            print("Error Code: ", sqlite3_errcode (contactDB));
            let error = String.fromCString(sqlite3_errmsg(contactDB));
            print("Error msg: ",error);
        }
        sqlite3_reset(updateStatement);
        sqlite3_clear_bindings(updateStatement);
        return contact
    }
    
    
    func deleteContact(name : NSString, phone : NSString) -> Contact {
  
        let contact : Contact = Contact()
        
        let nameStr = name
        
        let phoneStr = phone
        
        sqlite3_bind_text(deleteStatement, 1, nil, -1, SQLITE_TRANSIENT);
        
        
        if(sqlite3_step(deleteStatement) == SQLITE_DONE){
            contact.name = name as String
            contact.phoneNumber = phone as String
            contact.status = "Contact Deleted"
        }
        else {
            contact.status = "Failed to delete contact";
            print("Error code: ",sqlite3_errcode(contactDB));
            let error = String.fromCString(sqlite3_errmsg(contactDB));
            print("Error msg: ", error);
        }
        
        sqlite3_reset(deleteStatement);
        sqlite3_clear_bindings(deleteStatement);

    return contact
        
    }
 

    func loadContact() -> Contact {
        
        let contact : Contact = Contact()
        
        while(sqlite3_step(selectStatement) == SQLITE_ROW)
        {
            
            let contact_buf = String.fromCString(UnsafePointer<CChar>(sqlite3_column_text(selectStatement, 1)))
            let phn_buf = String.fromCString(UnsafePointer<CChar>(sqlite3_column_text(selectStatement, 2)))
            if(contact_buf != nil && phn_buf != nil){
                
                contact.name = contact_buf
                contact.phoneNumber = phn_buf
                contact.status = "Contact added"
            }
        }
        sqlite3_reset(selectStatement)
        sqlite3_clear_bindings(selectStatement)
        return contact
    }
}
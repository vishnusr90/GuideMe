//
//  DataBaseTable.swift
//  GuideMe
//
//  Created by student on 6/5/16.
//  Copyright © 2016 ISS. All rights reserved.
//

import Foundation

class DataBaseTable {
    
    static var databaseInstance : DataBaseTable?
    
    var beaconDB: COpaquePointer = nil
    var contactDB: COpaquePointer = nil
    var insertStatement : COpaquePointer = nil
    var selectStatement : COpaquePointer = nil
    var updateStatement : COpaquePointer = nil
    var deleteStatement : COpaquePointer = nil
    
    let SQLITE_TRANSIENT = unsafeBitCast(-1, sqlite3_destructor_type.self)

    
    static func getInstance() -> DataBaseTable {
        
        if(databaseInstance == nil){
            databaseInstance = DataBaseTable()
        }
        return databaseInstance!
    }
    
    func createTable() {
        
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        print("Paths : " + paths)
        let docsDir = paths + "/guideME.sqlite"
 
        
        if (sqlite3_open(docsDir, &beaconDB) == SQLITE_OK) {
            
            
            let sql = "CREATE TABLE IF NOT EXISTS BEACON (MINOR INTEGER PRIMARY KEY , LOCATION TEXT, VOICEMESSAGE TEXT, IMAGE TEXT)"
            
            if (sqlite3_exec(beaconDB, sql, nil, nil, nil) != SQLITE_OK) {
                print("Failed to create table")
                print(sqlite3_errmsg(beaconDB))
            }
        } else {
            print("Failed to open database")
            print(sqlite3_errmsg(beaconDB))
        }
     
        deleteContents()

        prepareStatement()
        
    }
    func deleteContents() {
        var sqlString : String
        sqlString = "DELETE FROM BEACON"
        var cSql = sqlString.cStringUsingEncoding(NSUTF8StringEncoding)
        sqlite3_prepare_v2(beaconDB,cSql!, -1, &deleteStatement, nil)
        
        if(sqlite3_step(deleteStatement) ==  SQLITE_DONE) {
            
            print("Successfully deleted the records")
            
        }else {
            
            print("Failed to delete records")
            print("Error code in delete: ", sqlite3_errcode(beaconDB))
            let error = String.fromCString(sqlite3_errmsg(beaconDB))
            print("Error msg in delete records: ", error)
        }
        
        sqlite3_reset(deleteStatement)
        sqlite3_clear_bindings(deleteStatement)

    }
    
    func prepareStatement() {
        var sqlString : String
        
        sqlString = "INSERT INTO BEACON (minor , location, voicemessage, image) VALUES (?,?,?,?)"
        var cSql = sqlString.cStringUsingEncoding(NSUTF8StringEncoding)
        sqlite3_prepare_v2(beaconDB,cSql!, -1, &insertStatement, nil)
        
        
        sqlString = "SELECT voicemessage, image, location FROM BEACON WHERE minor = ?"
        cSql = sqlString.cStringUsingEncoding(NSUTF8StringEncoding)
        sqlite3_prepare_v2(beaconDB,cSql!, -1, &selectStatement, nil)
        
        
//        sqlString = "DELETE FROM BEACON WHERE name = ?"
//        cSql = sqlString.cStringUsingEncoding(NSUTF8StringEncoding)
//        sqlite3_prepare_v2(contactDB,cSql!, -1, &deleteStatement, nil)
        
        
//        sqlString = "UPDATE BEACON SET address = ?, phone = ? WHERE name = ?"
//        cSql = sqlString.cStringUsingEncoding(NSUTF8StringEncoding)
//        sqlite3_prepare_v2(contactDB,cSql!, -1, &updateStatement, nil)
        
        loadData()
    }
    
    func loadData() {
        
        let entrance : String = "Welcome to Clementi MRT Station. Besides you is the entrance. Please use the escalator"
        let crossing : String = "You have reached the crossing. On your left is the passenger service centre. On your right is the elevator"
        let seven_eleven : String = "On your right is the seven eleven store"
        let barrier : String = "You are approaching the barrier. Please swipe your card"
        
        
        sqlite3_bind_int(insertStatement, 1, Int32(10))
        sqlite3_bind_text(insertStatement, 2, "Entrance", -1, SQLITE_TRANSIENT)
        sqlite3_bind_text(insertStatement, 3, entrance, -1, SQLITE_TRANSIENT)
        sqlite3_bind_text(insertStatement, 4, "entrance", -1, SQLITE_TRANSIENT)
        
        
        if(sqlite3_step(insertStatement) ==  SQLITE_DONE) {
            
            print("Successfully inserted beacon 1")
            
        }else {
            
            print("Failed to add beacon")
            print("Error code: ", sqlite3_errcode(beaconDB))
            let error = String.fromCString(sqlite3_errmsg(beaconDB))
            print("Error msg in create: ", error)
        }
        
        sqlite3_reset(insertStatement)
    
        sqlite3_bind_int(insertStatement, 1, Int32(15))
        sqlite3_bind_text(insertStatement, 2, "Seven - Eleven store", -1, SQLITE_TRANSIENT)
        sqlite3_bind_text(insertStatement, 3, seven_eleven, -1, SQLITE_TRANSIENT)
        sqlite3_bind_text(insertStatement, 4, "7-11", -1, SQLITE_TRANSIENT)
        
        if(sqlite3_step(insertStatement) ==  SQLITE_DONE) {
            
            print("Successfully inserted beacon 2")
            
        }else {
            
            print("Failed to add beacon")
            print("Error code: ", sqlite3_errcode(contactDB))
            let error = String.fromCString(sqlite3_errmsg(contactDB))
            print("Error msg in create: ", error)
        }
        
        sqlite3_reset(insertStatement)
        
        sqlite3_reset(insertStatement)
        
        sqlite3_bind_int(insertStatement, 1, Int32(20))
        sqlite3_bind_text(insertStatement, 2, "Barrier", -1, SQLITE_TRANSIENT)
        sqlite3_bind_text(insertStatement, 3, barrier, -1, SQLITE_TRANSIENT)
        sqlite3_bind_text(insertStatement, 4, "barrier", -1, SQLITE_TRANSIENT)
        
        if(sqlite3_step(insertStatement) ==  SQLITE_DONE) {
            
            print("Successfully inserted beacon 3")
            
        }else {
            
            print("Failed to add beacon")
            print("Error code: ", sqlite3_errcode(contactDB))
            let error = String.fromCString(sqlite3_errmsg(contactDB))
            print("Error msg in create: ", error)
        }
        
        sqlite3_reset(insertStatement)
        
        sqlite3_bind_int(insertStatement, 1, Int32(25))
        sqlite3_bind_text(insertStatement, 2, "Elevator", -1, SQLITE_TRANSIENT)
        sqlite3_bind_text(insertStatement, 3, crossing, -1, SQLITE_TRANSIENT)
        sqlite3_bind_text(insertStatement, 4, "elevator", -1, SQLITE_TRANSIENT)
        
        if(sqlite3_step(insertStatement) ==  SQLITE_DONE) {
            
            print("Successfully inserted beacon 4")
            
        }else {
            
            print("Failed to add beacon")
            print("Error code: ", sqlite3_errcode(beaconDB))
            let error = String.fromCString(sqlite3_errmsg(beaconDB))
            print("Error msg in create: ", error)
        }
        
        sqlite3_reset(insertStatement)
        
        sqlite3_clear_bindings(insertStatement)

    }
    
    
    func fetchBeaconData(minorValue : Int32) -> Location {
        
        let location: Location = Location()
        
        sqlite3_bind_int(selectStatement, 1, minorValue)
        
        
        if(sqlite3_step(selectStatement) ==  SQLITE_ROW) {
            
            
            let voiceMessage = sqlite3_column_text(selectStatement, 0)
            location.voiceMessage = String.fromCString(UnsafePointer<CChar>(voiceMessage))!
            
            let image = sqlite3_column_text(selectStatement, 1)
            location.imageURL = String.fromCString(UnsafePointer<CChar>(image))!
            
            let locationDescription = sqlite3_column_text(selectStatement, 1)
            location.location = String.fromCString(UnsafePointer<CChar>(locationDescription))!

            
        }else {
            
            print("Error code: ", sqlite3_errcode(beaconDB))
            let error = String.fromCString(sqlite3_errmsg(beaconDB))
            print("Error msg in find: ", error)
        }
        
        sqlite3_reset(selectStatement)
        sqlite3_clear_bindings(selectStatement)
        
        return location
    }
}

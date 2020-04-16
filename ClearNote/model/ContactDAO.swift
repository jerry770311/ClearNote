//
//  ContactDAO.swift
//  ClearNote
//
//  Created by apple on 2018/10/29.
//  Copyright © 2018 apple. All rights reserved.
//

import Foundation
class ContactDAO {
    //計算屬性
    static var dbPath : String{
        //路徑
        let target = "\(NSHomeDirectory())/Documents/db.sqlite"
        let fileMgr = FileManager.default
        if !fileMgr.fileExists(atPath: target){
            let source = Bundle.main.path(forResource: "ContactsDB", ofType: "sqlite")!
            try? fileMgr.copyItem(atPath: source, toPath: target)
        }
        return target
    }
    static func getAllContacts()->[Contact]{
        var list = [Contact]()
        //建立讀取的db
        let db = FMDatabase(path: dbPath)
        db?.open()
        //executeQuery查詢
        if let result = db?.executeQuery("SELECT * FROM Contacts", withArgumentsIn: []){
            //如果有下一筆值就把資料抓出
            while result.next(){
                let sid = result.int(forColumn: "sid")
                let text = result.string(forColumn: "text")
                let completed = result.bool(forColumn: "completed")
                let data = Contact(sid:Int(sid),text:text!,completed:completed)
                list.append(data)
            }
            result.close()
        }
        db?.close()
        return list
    }
    //查詢sid
    static func getContactBySid(sid:Int)->Contact?{
        //宣告型別要和回傳的型別一樣
        var ret : Contact?
        //建立讀取的db
        let db = FMDatabase(path: dbPath)
        db?.open()
        //executeQuery查詢
        if let result = db?.executeQuery("SELECT * FROM Contacts WHERE sid = \(sid)", withArgumentsIn: []){
            //如果有下一筆值就把資料抓出
            while result.next(){
                let sid = result.int(forColumn: "sid")
                let text = result.string(forColumn: "text")
                let completed = result.bool(forColumn: "completed")
                let data = Contact(sid:Int(sid),text:text!,completed:completed)
                break
            }
            result.close()
        }
        db?.close()
        return ret
    }
    //新增
    static func insert(data:Contact){
        var dict = [String:Any]()
        dict["t"] = data.text
        
        let db = FMDatabase(path: dbPath)
        db?.open()
        db?.executeUpdate("INSERT INTO Contacts (content) VALUES (:c);", withParameterDictionary: dict)
        db?.close()
    }
    //修改
    static func update(data:Contact){
        var dict = [String:Any]()
        dict["sid"] = data.sid
        dict["t"] = data.text
        let db = FMDatabase(path: dbPath)
        db?.open()
        db?.executeUpdate("UPDATE Contacts SET content=:c WHERE sid=:sid;", withParameterDictionary: dict)
        db?.close()
    }
    //刪除
    static func delete(sid:Int){
        var dict = [String:Any]()
        dict["sid"] = sid
        let db = FMDatabase(path: dbPath)
        db?.open()
        db?.executeUpdate("DELETE FROM Contacts WHERE sid = :sid;", withParameterDictionary: dict)
        db?.close()
    }
}

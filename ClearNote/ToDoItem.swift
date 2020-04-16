//
//  ToDoItem.swift
//  ClearNote
//
//  Created by apple on 2018/10/13.
//  Copyright © 2018 apple. All rights reserved.
//

import UIKit

class ToDoItem: NSObject,NSCoding{
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.text, forKey: "text")
        aCoder.encode(self.completed, forKey: "completed")
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        if let title = aDecoder.decodeObject(forKey: "text") as? String
        {
            self.text = title
        }
        else
        {
            return nil
        }
        
        if aDecoder.containsValue(forKey: "completed")
        {
            self.completed = aDecoder.decodeBool(forKey: "completed")
        }
        else
        {
            return nil
        }
    }
    
    
    var text : String
    var completed : Bool
    
    public init(text:String){
        self.text = text
        self.completed = false
    }
}
extension Collection where Iterator.Element == ToDoItem
{
    private static func persistencePath() -> URL?
    {
        let url = try? FileManager.default.url(
            for: .applicationSupportDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true)
        
        return url?.appendingPathComponent("todoitems.bin")
    }
    func writeToPersistence() throws
    {
        if let url = Self.persistencePath(), let array = self as? NSArray
        {
            let data = NSKeyedArchiver.archivedData(withRootObject: array)
            try data.write(to: url)
        }
        else
        {
            throw NSError(domain: "com.example.ToDoItem", code: 10, userInfo: nil)
        }
    }
    
    static func readFromPersistence() throws -> [ToDoItem]
    {
        if let url = persistencePath(), let data = (try Data(contentsOf: url) as Data?)
        {
            if let array = NSKeyedUnarchiver.unarchiveObject(with: data) as? [ToDoItem]
            {
                return array
            }
            else
            {
                throw NSError(domain: "com.example.ToDoItem", code: 11, userInfo: nil)
            }
        }
        else
        {
            throw NSError(domain: "com.example.ToDoItem", code: 12, userInfo: nil)
        }
    }
}

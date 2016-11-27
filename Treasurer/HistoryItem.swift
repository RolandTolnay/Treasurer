//
//  HistoryItem.swift
//  Treasurer
//
//  Created by Roland Tolnay on 01/12/15.
//  Copyright © 2015 Roland Tolnay. All rights reserved.
//

import UIKit

extension NSDate
{
    convenience
    init(dateString:String) {
        let dateStringFormatter = NSDateFormatter()
        dateStringFormatter.dateFormat = "yyyy-MM-dd"
        dateStringFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        let d = dateStringFormatter.dateFromString(dateString)!
        self.init(timeInterval:0, sinceDate:d)
    }
}

class HistoryItem: NSObject, NSCoding {
    
    //MARK: Properties
    
    var date: NSDate
    
    //MARK: Archiving Paths
    
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("history")
    
    // MARK: NSCoding keys
    
    struct PropertyKey {
        static let dateKey = "date"
    }
    
    //MARK: Init
    
    init(date: NSDate) {
        self.date = date
        super.init()
    }
    
    //MARK: NSCoding

    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(date, forKey: PropertyKey.dateKey)
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let date = aDecoder.decodeObjectForKey(PropertyKey.dateKey) as! NSDate
        
        self.init(date: date)
    }

    static func loadHistory() -> [HistoryItem]? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(HistoryItem.ArchiveURL.path!) as? [HistoryItem]
    }
    
}

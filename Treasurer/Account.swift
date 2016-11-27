//
//  Account.swift
//  Treasurer
//
//  Created by Roland Tolnay on 01/12/15.
//  Copyright © 2015 Roland Tolnay. All rights reserved.
//

import UIKit

extension NSDate
{
    func isGreaterThanDate(dateToCompare : NSDate) -> Bool
    {
        return self.compare(dateToCompare) == NSComparisonResult.OrderedDescending
    }
}

class Account: NSObject, NSCoding {

    //MARK: Singleton
    
    static let sharedInstance = Account()
    
    //MARK: Properties
    
    var totalMoney: Double
    var history: [HistoryItem]
    
    //MARK: Archiving Paths
    
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("account")
    
    // MARK: NSCoding keys
    
    struct PropertyKey {
        static let totalMoneyKey = "totalMoney"
    }
    
    //MARK: Init
    
    override init() {
        self.totalMoney = 0
        if let savedHistory = HistoryItem.loadHistory() {
            history = savedHistory
            history.sortInPlace({ $0.date.isGreaterThanDate($1.date) })
        } else {
            history = [HistoryItem]()
        }
        super.init()
    }
    
    
    //MARK: NSCoding
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeDouble(totalMoney, forKey: PropertyKey.totalMoneyKey)
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let totalMoney = aDecoder.decodeDoubleForKey(PropertyKey.totalMoneyKey)
        
        self.init()
        self.totalMoney = totalMoney
    }

    static  func loadAccount() -> Account? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(Account.ArchiveURL.path!) as? Account
    }
    
    func saveHistory() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(history, toFile: HistoryItem.ArchiveURL.path!)
        if !isSuccessfulSave {
            print("Failed to save history")
        }

    }
 
    
}

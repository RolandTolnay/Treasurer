//
//  Deposit.swift
//  Treasurer
//
//  Created by Roland Tolnay on 01/12/15.
//  Copyright © 2015 Roland Tolnay. All rights reserved.
//

import UIKit

extension HistoryItem.PropertyKey {
    static let messageKey = "message"
    static let amountKey = "amount"
}

class Deposit: HistoryItem {
    
    //MARK: Properties
    
    var message: String
    var amount: Double
    
    //MARK: Initializer
    
    init(message:String, amount: Double, date: NSDate) {
        self.message = message
        self.amount = amount
        
        super.init(date: date)
    }
    
    //MARK: NSCoding
    
    override func encodeWithCoder(aCoder: NSCoder) {
        super.encodeWithCoder(aCoder)
        aCoder.encodeObject(message, forKey: PropertyKey.messageKey)
        aCoder.encodeDouble(amount, forKey: PropertyKey.amountKey)
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let message = aDecoder.decodeObjectForKey(PropertyKey.messageKey) as! String
        let amount = aDecoder.decodeDoubleForKey(PropertyKey.amountKey)
        let date = aDecoder.decodeObjectForKey(PropertyKey.dateKey) as! NSDate
        
        self.init(message: message, amount: amount, date: date)
    }

}

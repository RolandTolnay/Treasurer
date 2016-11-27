//
//  Purchase.swift
//  Treasurer
//
//  Created by Roland Tolnay on 30/11/15.
//  Copyright © 2015 Roland Tolnay. All rights reserved.
//

import UIKit

extension HistoryItem.PropertyKey {
    static let itemNameKey = "itemName"
    static let numberOfItemsKey = "numberOfItems"
    static let priceKey = "price"
}

class Purchase: HistoryItem {
    
    //MARK: Properties
    
    var itemName: String
    var numberOfItems: Int
    var price: Double
    
    //MARK: Initializer
    
    init(itemName:String, numberOfItems: Int, price: Double, date: NSDate) {
        self.itemName = itemName
        self.numberOfItems = numberOfItems
        self.price = price
        
        super.init(date: date)
    }
    
    //MARK: NSCoding
    
    override func encodeWithCoder(aCoder: NSCoder) {
        super.encodeWithCoder(aCoder)
        aCoder.encodeObject(itemName, forKey: PropertyKey.itemNameKey)
        aCoder.encodeInteger(numberOfItems, forKey: PropertyKey.numberOfItemsKey)
        aCoder.encodeDouble(price, forKey: PropertyKey.priceKey)
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let itemName = aDecoder.decodeObjectForKey(PropertyKey.itemNameKey) as! String
        let numberOfItems = aDecoder.decodeIntegerForKey(PropertyKey.numberOfItemsKey)
        let price = aDecoder.decodeDoubleForKey(PropertyKey.priceKey)
        let date = aDecoder.decodeObjectForKey(PropertyKey.dateKey) as! NSDate
        
        self.init(itemName: itemName, numberOfItems: numberOfItems, price: price, date: date)
    }

}
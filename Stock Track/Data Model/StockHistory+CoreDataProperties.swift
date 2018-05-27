//
//  StockHistory+CoreDataProperties.swift
//  Stock Track
//
//  Created by Zhihao Cui on 27/05/2018.
//  Copyright © 2018 Zhihao Cui. All rights reserved.
//
//

import Foundation
import CoreData


extension StockHistory {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StockHistory> {
        return NSFetchRequest<StockHistory>(entityName: "StockHistory")
    }

    @NSManaged public var timestamp: NSDate?
    @NSManaged public var amount: Float
    @NSManaged public var item: StockItem?

}

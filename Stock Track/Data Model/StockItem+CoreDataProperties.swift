//
//  StockItem+CoreDataProperties.swift
//  Stock Track
//
//  Created by Zhihao Cui on 27/05/2018.
//  Copyright © 2018 Zhihao Cui. All rights reserved.
//
//

import Foundation
import CoreData


extension StockItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StockItem> {
        return NSFetchRequest<StockItem>(entityName: "StockItem")
    }

    @NSManaged public var timestamp: NSDate?
    @NSManaged public var name: String?
    @NSManaged public var photo: NSData?
    @NSManaged public var amountLeft: Float
    @NSManaged public var packageCount: Float
    @NSManaged public var isDeseret: Bool
    @NSManaged public var consumptionDailyRate: Float
    @NSManaged public var history: NSOrderedSet?

}

// MARK: Generated accessors for history
extension StockItem {

    @objc(insertObject:inHistoryAtIndex:)
    @NSManaged public func insertIntoHistory(_ value: StockHistory, at idx: Int)

    @objc(removeObjectFromHistoryAtIndex:)
    @NSManaged public func removeFromHistory(at idx: Int)

    @objc(insertHistory:atIndexes:)
    @NSManaged public func insertIntoHistory(_ values: [StockHistory], at indexes: NSIndexSet)

    @objc(removeHistoryAtIndexes:)
    @NSManaged public func removeFromHistory(at indexes: NSIndexSet)

    @objc(replaceObjectInHistoryAtIndex:withObject:)
    @NSManaged public func replaceHistory(at idx: Int, with value: StockHistory)

    @objc(replaceHistoryAtIndexes:withHistory:)
    @NSManaged public func replaceHistory(at indexes: NSIndexSet, with values: [StockHistory])

    @objc(addHistoryObject:)
    @NSManaged public func addToHistory(_ value: StockHistory)

    @objc(removeHistoryObject:)
    @NSManaged public func removeFromHistory(_ value: StockHistory)

    @objc(addHistory:)
    @NSManaged public func addToHistory(_ values: NSOrderedSet)

    @objc(removeHistory:)
    @NSManaged public func removeFromHistory(_ values: NSOrderedSet)

}

//
//  Item+CoreDataProperties.swift
//  DMMerch
//
//  Created by Sean Laughlin on 7/31/23.
//
//

import Foundation
import CoreData


extension Item {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var image: Data?
    @NSManaged public var name: String?
    @NSManaged public var price: Int16
    @NSManaged public var sold: Int16
    @NSManaged public var type: String?
    @NSManaged public var discontinuedDate: Date?
    @NSManaged public var lastOrderAmt: Int16
    @NSManaged public var lastOrderDate: Date?
    @NSManaged public var lastOrderCost: Int16
    @NSManaged public var totalItemInventory: Int16
    @NSManaged public var discontinued: Bool
    @NSManaged public var tag: String?
    @NSManaged public var itemColors: NSSet?

    public var colorArray: [ItemColor] {
        let set = itemColors as? Set<ItemColor> ?? []
        
        return set.sorted {
            $0.wrappedName < $1.wrappedName
        }
    }
}

// MARK: Generated accessors for itemColors
extension Item {

    @objc(addItemColorsObject:)
    @NSManaged public func addToItemColors(_ value: ItemColor)

    @objc(removeItemColorsObject:)
    @NSManaged public func removeFromItemColors(_ value: ItemColor)

    @objc(addItemColors:)
    @NSManaged public func addToItemColors(_ values: NSSet)

    @objc(removeItemColors:)
    @NSManaged public func removeFromItemColors(_ values: NSSet)

}

extension Item : Identifiable {

}

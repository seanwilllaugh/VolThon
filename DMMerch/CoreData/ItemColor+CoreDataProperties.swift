//
//  ItemColor+CoreDataProperties.swift
//  DMMerch
//
//  Created by Sean Laughlin on 7/26/23.
//
//

import Foundation
import CoreData


extension ItemColor {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ItemColor> {
        return NSFetchRequest<ItemColor>(entityName: "ItemColor")
    }

    @NSManaged public var colorName: String?
    @NSManaged public var id: UUID?
    @NSManaged public var totalColorInventory: Int16
    @NSManaged public var colorSizes: NSSet?
    @NSManaged public var item: Item?

    public var wrappedName: String {
        colorName ?? "Unknown Color"
    }
}

// MARK: Generated accessors for colorSizes
extension ItemColor {

    @objc(addColorSizesObject:)
    @NSManaged public func addToColorSizes(_ value: ItemSize)

    @objc(removeColorSizesObject:)
    @NSManaged public func removeFromColorSizes(_ value: ItemSize)

    @objc(addColorSizes:)
    @NSManaged public func addToColorSizes(_ values: NSSet)

    @objc(removeColorSizes:)
    @NSManaged public func removeFromColorSizes(_ values: NSSet)

    public var sizeArray: [ItemSize] {
        let set = colorSizes as? Set<ItemSize> ?? []
        
        return set.sorted {
            $0.wrappedName < $1.wrappedName
        }
    }
}

extension ItemColor : Identifiable {

}

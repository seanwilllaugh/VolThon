//
//  ItemSize+CoreDataProperties.swift
//  DMMerch
//
//  Created by Sean Laughlin on 7/26/23.
//
//

import Foundation
import CoreData


extension ItemSize {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ItemSize> {
        return NSFetchRequest<ItemSize>(entityName: "ItemSize")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var sizeName: String?
    @NSManaged public var inventory: Int16
    @NSManaged public var color: ItemColor?
    
    public var wrappedName: String {
        sizeName ?? "Unknown Size"
    }
}

extension ItemSize : Identifiable {

}

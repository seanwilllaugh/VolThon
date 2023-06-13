//
//  Item+CoreDataProperties.swift
//  DMMerch
//
//  Created by Sean Laughlin on 3/9/23.
//
//

import Foundation
import CoreData


extension Item {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item")
    }

    @NSManaged public var colors: String?
    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var price: Int16
    @NSManaged public var sizes: String?
    @NSManaged public var type: String?
    @NSManaged public var image: Data?
    @NSManaged public var sold: Int16

}

extension Item : Identifiable {

}

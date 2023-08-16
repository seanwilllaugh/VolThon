//
//  ItemType+CoreDataProperties.swift
//  DMMerch
//
//  Created by Sean Laughlin on 7/25/23.
//
//

import Foundation
import CoreData


extension ItemType {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ItemType> {
        return NSFetchRequest<ItemType>(entityName: "ItemType")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var typeCount: Int16
    @NSManaged public var typeSales: Int16

}

extension ItemType : Identifiable {

}

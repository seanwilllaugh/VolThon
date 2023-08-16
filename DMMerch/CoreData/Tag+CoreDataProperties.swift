//
//  Tag+CoreDataProperties.swift
//  DMMerch
//
//  Created by Sean Laughlin on 7/25/23.
//
//

import Foundation
import CoreData


extension Tag {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Tag> {
        return NSFetchRequest<Tag>(entityName: "Tag")
    }

    @NSManaged public var dateEnd: Date?
    @NSManaged public var dateStart: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var name: String?

}

extension Tag : Identifiable {

}

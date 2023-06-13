//
//  Purchase+CoreDataProperties.swift
//  DMMerch
//
//  Created by Sean Laughlin on 2/20/23.
//
//

import Foundation
import CoreData


extension Purchase {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Purchase> {
        return NSFetchRequest<Purchase>(entityName: "Purchase")
    }

    @NSManaged public var buyer: String?
    @NSManaged public var id: UUID?
    @NSManaged public var items: String?
    @NSManaged public var method: String?
    @NSManaged public var totalItems: Int16
    @NSManaged public var totalPrice: Int16
    @NSManaged public var purchaseTime: String
    @NSManaged public var phone : String
    @NSManaged public var email : String
    @NSManaged public var top : Date?

}

extension Purchase : Identifiable {

}

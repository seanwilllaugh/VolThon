//
//  PurchaseStruct.swift
//  DMMerch
//
//  Created by Sean Laughlin on 2/19/23.
//

import Foundation

struct cartItem: Hashable{
    var itemName     : String?
    var itemPrice    : Int?
    var itemQuantity : Int?
    var itemColor    : String?
    var itemSize     : String?
    var itemType     : String?
    
    var size         : ItemSize?
}

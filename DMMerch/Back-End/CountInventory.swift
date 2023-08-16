//
//  SwiftUIView.swift
//  DMMerch
//
//  Created by Sean Laughlin on 7/31/23.
//

import SwiftUI


func countInventoryTotal(item: Item) -> Int{
    var inventoryCount = 0
    
    for color in item.colorArray{
        for size in color.sizeArray{
            inventoryCount = inventoryCount + Int(size.inventory)
        }
    }
    
    return inventoryCount
}

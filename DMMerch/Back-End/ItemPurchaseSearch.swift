//
//  ItemPurchaseSearch.swift
//  DMMerch
//
//  Created by Sean Laughlin on 7/31/23.
//

import SwiftUI

func findItemPurchases(itemName : String, purchases: FetchedResults<Purchase>) -> [Purchase]{
    @Environment(\.managedObjectContext) var viewContext
    var filteredPurchases = [Purchase]()
    
    for purchase in purchases {
        let allUnformattedItems = String(purchase.items!).split(separator: ";")
        
        for unformattedItem in allUnformattedItems {
            let formattedItem = unformattedItem.split(separator: ",")
            
            if(formattedItem[1] == itemName){
                filteredPurchases.append(purchase)
            }
        }
    }
    
    return filteredPurchases
}

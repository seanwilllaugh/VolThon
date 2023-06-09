//
//  csvExport.swift
//  DMMerch
//
//  Created by Sean Laughlin on 4/23/23.
//

import Foundation
import SwiftUI
import CoreData
import UIKit

func writetoCSV() {
    // Fetch the managed object context
    @Environment(\.managedObjectContext) var viewContext
    @FetchRequest(sortDescriptors: [], animation: .default) var items: FetchedResults<Item>
    
    // Create a new CSV file
    let fileName = "items.csv"
    let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    let fileURL = documentsDirectory.appendingPathComponent(fileName)

    // Write the entities to the CSV file
    var csvText = "Name,Description,Price\n"
    for item in items {
        let name = item.name ?? ""
        let type = item.type ?? ""
        let price = item.price
        let newLine = "\(name),\(type),\(price)\n"
        csvText.append(newLine)
    }
    do {
        try csvText.write(to: fileURL, atomically: true, encoding: .utf8)
        print("CSV file created at path: \(fileURL)")
    } catch {
        print("Error creating CSV file: \(error)")
    }
}


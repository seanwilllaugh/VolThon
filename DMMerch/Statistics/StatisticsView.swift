//
//  StatisticsView.swift
//  DMMerch
//
//  Created by Sean Laughlin on 3/24/23.
//

import SwiftUI
import CoreData
import Foundation

struct StatisticsView: View {
    @Environment(\.managedObjectContext) var viewContext
    @FetchRequest(sortDescriptors: [], animation: .default) var items: FetchedResults<Item>
    @FetchRequest(sortDescriptors: [], animation: .default) var purchases: FetchedResults<Purchase>
    
    var body: some View {
        List{
            ForEach(items){ item in
                HStack{
                    Text(item.name!)
                }
            }
        }
        Button{
            print("Starting CSV Export...")
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
                print("added \(name)")
            }
            do {
                try csvText.write(to: fileURL, atomically: true, encoding: .utf8)
                print("CSV file created at path: \(fileURL)")
            } catch {
                print("Error creating CSV file: \(error)")
            }
        } label: {
            Text("Export to CSV")
        }
    }
}

struct StatisticsView_Previews: PreviewProvider {
    static var previews: some View {
        StatisticsView()
    }
}

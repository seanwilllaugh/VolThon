//
//  ExportCSV.swift
//  DMMerch
//
//  Created by Sean Laughlin on 6/14/23.
//

import SwiftUI
import CoreData
import Foundation

struct ExportCSV: View {
    @Environment(\.managedObjectContext) var viewContext
    
    @State var sortedPurchases: [Purchase]
    @FetchRequest(sortDescriptors: [], animation: .default) var items: FetchedResults<Item>
    @FetchRequest(sortDescriptors: [], animation: .default) var tags: FetchedResults<Tag>
    @State private var typeList = ["Clothing", "Buttons", "Flowers", "Bags", "Stickers", "Bottles", "Other"]
    
    var hexColors = readColors()
    
    @State var csvFileURL = URL(string: "www.seanwlaughlin.com")
    
    @State private var filterType   = false
    @State private var selectedType = ""
    
    @State private var filterTag   = false
    @State private var selectedTag = ""
    
    @State private var filterDate    = false
    @State private var selectedStart = Date()
    @State private var selectedEnd   = Date()
    
    @State private var filterItem  = false
    @State private var selectedItem = ""
    
    @State private var filterBuyer = false
    @State private var selectedBuyer = ""
    
    @State private var filterNone = true
    
    var body: some View {
        VStack{
            Text("Export Data")
                .font(.title)
                .fontWeight(.medium)
                .fontDesign(.rounded)
                .padding(.top)
            
            NavigationStack{
                Form{
                    HStack{
                        Spacer()
                        Text("Select Filters")
                            .font(.title)
                            .fontWeight(.medium)
                            .fontDesign(.rounded)
                        Spacer()
                    }
                    Section{
                        Toggle("Type", isOn: $filterType)
                        if(filterType){
                            Picker("Select Item Type(s)", selection: $selectedType){
                                ForEach(typeList, id: \.self){
                                    Text("\($0)")
                                }
                            }
                        }
                    }
                    
                    Section{
                        Toggle("Tag", isOn: $filterTag)
                        if(filterTag){
                            Picker("Select a Tag", selection: $selectedTag){
                                ForEach(tags.indices, id: \.self){ index in
                                    Text("\(tags[index].name!)")
                                        .tag(tags[index].name!)
                                }
                            }
                        }
                    }
                    
                    Section{
                        Toggle("Date", isOn: $filterDate)
                        if(filterDate){
                            DatePicker("Select START date", selection: $selectedStart, displayedComponents: .date)
                            DatePicker("Select END date", selection: $selectedEnd, displayedComponents: .date)
                        }
                        
                    }
                    
                    Section{
                        Toggle("Item", isOn: $filterItem)
                        if(filterItem){
                            Picker("Select Item(s)", selection: $selectedItem){
                                ForEach(items.indices, id: \.self){ index in
                                    Text("\(items[index].name!)")
                                        .tag(items[index].name!)
                                }
                            }
                            .pickerStyle(.navigationLink)
                        }
                    }
                    
                    Section{
                        Toggle("Individual", isOn: $filterBuyer)
                        if(filterBuyer){
                            Picker("Select an Individual", selection: $selectedBuyer){
                                ForEach(sortedPurchases.indices, id: \.self){ index in
                                    Text(sortedPurchases[index].buyer!)
                                        .tag(sortedPurchases[index].buyer!)
                                }
                            }
                            .pickerStyle(.navigationLink)
                        }
                    }
                }
            }
            
            
            Spacer()
            
            Button{
                do {
                    csvFileURL = try saveCSVFile()
                    // Perform any additional actions with the CSV file URL, such as sharing or saving it
                    
                } catch {
                    print("Error exporting to CSV: \(error.localizedDescription)")
                }
            } label: {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(hex: findHex(color: "Pastel Orange", hexColors: hexColors))!)
                    .overlay(
                        Text("Save CSV Filters")
                            .font(.title3)
                            .fontWeight(.medium)
                            .fontDesign(.rounded)
                            .foregroundColor(.white)
                    )
                    .frame(width: 250, height: 50)
                    .padding(.bottom)
            }
            
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(hex: findHex(color: "Pastel Orange", hexColors: hexColors))!)
                .overlay(
                    ShareLink(item: csvFileURL!){
                        Label("Export CSV", systemImage: "square.and.arrow.up")
                    }
                )
                .padding(.bottom)
                .frame(width: 250, height: 100)
        }
        .navigationTitle("Create and Export CSV")
    }
    
    private func createCSVContent() -> String {
        var csvString = "Time of Purchase,Name,Total,# of Items\n"
        for purchase in sortedPurchases {
            
            if(filterType){
                filterNone = false
                var pass = false
                
                let allUnformattedItems = String(purchase.items!).split(separator: ";")
                
                for item in allUnformattedItems{
                    let oneUnformattedItem = item.split(separator: ",")
                    let item = items.first(where: {$0.name == String(oneUnformattedItem[1])})
                    if(item!.type! == selectedType){
                        pass = true
                        break
                    }
                }
                
                if(pass){
                    let total = "\(purchase.totalPrice)"
                    let itemsnum = "\(purchase.totalItems)"
                    
                    if let top = purchase.top, let buyer = purchase.buyer {
                        let csvLine = "\(top),\(buyer),\(total),\(itemsnum)\n"
                        csvString.append(csvLine)
                    }
                    
                    for item in allUnformattedItems{
                        let oneUnformattedItem = item.split(separator: ",")
                        let csvLine = "\(oneUnformattedItem[0]),\(oneUnformattedItem[1]),\(oneUnformattedItem[2]),\(oneUnformattedItem[3])\n"
                        csvString.append(csvLine)
                    }
                }
            }
            
            if(filterTag){
                filterNone = false
                
                if(purchase.tag! == selectedTag){
                    let total = "\(purchase.totalPrice)"
                    let itemsnum = "\(purchase.totalItems)"
                    
                    if let top = purchase.top, let buyer = purchase.buyer {
                        let csvLine = "\(top),\(buyer),\(total),\(itemsnum)\n"
                        csvString.append(csvLine)
                    }
                    
                    let allUnformattedItems = String(purchase.items!).split(separator: ";")
                    for item in allUnformattedItems{
                        let oneUnformattedItem = item.split(separator: ",")
                        let csvLine = "\(oneUnformattedItem[0]),\(oneUnformattedItem[1]),\(oneUnformattedItem[2]),\(oneUnformattedItem[3])\n"
                        csvString.append(csvLine)
                    }
                }
            }
            
            if(filterDate){
                filterNone = false
                
                if(purchase.top! > selectedStart && purchase.top! < selectedEnd){
                    let total = "\(purchase.totalPrice)"
                    let itemsnum = "\(purchase.totalItems)"
                    
                    if let top = purchase.top, let buyer = purchase.buyer {
                        let csvLine = "\(top),\(buyer),\(total),\(itemsnum)\n"
                        csvString.append(csvLine)
                    }
                    
                    let allUnformattedItems = String(purchase.items!).split(separator: ";")
                    for item in allUnformattedItems{
                        let oneUnformattedItem = item.split(separator: ",")
                        let csvLine = "\(oneUnformattedItem[0]),\(oneUnformattedItem[1]),\(oneUnformattedItem[2]),\(oneUnformattedItem[3])\n"
                        csvString.append(csvLine)
                    }
                }
            }
            
            if(filterItem){
                filterNone = false
                var pass = false
                
                let allUnformattedItems = String(purchase.items!).split(separator: ";")
                
                for item in allUnformattedItems{
                    let oneUnformattedItem = item.split(separator: ",")
                    if(oneUnformattedItem[1] == selectedItem){
                        pass = true
                        break
                    }
                }
                
                if(pass){
                    let total = "\(purchase.totalPrice)"
                    let itemsnum = "\(purchase.totalItems)"
                    
                    if let top = purchase.top, let buyer = purchase.buyer {
                        let csvLine = "\(top),\(buyer),\(total),\(itemsnum)\n"
                        csvString.append(csvLine)
                    }
                    
                    for item in allUnformattedItems{
                        let oneUnformattedItem = item.split(separator: ",")
                        let csvLine = "\(oneUnformattedItem[0]),\(oneUnformattedItem[1]),\(oneUnformattedItem[2]),\(oneUnformattedItem[3])\n"
                        csvString.append(csvLine)
                    }
                }
            }
            
            if(filterBuyer){
                filterNone = false
                
                if(purchase.buyer! == selectedBuyer){
                    let total = "\(purchase.totalPrice)"
                    let itemsnum = "\(purchase.totalItems)"
                    
                    if let top = purchase.top, let buyer = purchase.buyer {
                        let csvLine = "\(top),\(buyer),\(total),\(itemsnum)\n"
                        csvString.append(csvLine)
                    }
                    
                    let allUnformattedItems = String(purchase.items!).split(separator: ";")
                    for item in allUnformattedItems{
                        let oneUnformattedItem = item.split(separator: ",")
                        let csvLine = "\(oneUnformattedItem[0]),\(oneUnformattedItem[1]),\(oneUnformattedItem[2]),\(oneUnformattedItem[3])\n"
                        csvString.append(csvLine)
                    }
                }
            }
            
            if(filterNone){
                let total = "\(purchase.totalPrice)"
                let itemsnum = "\(purchase.totalItems)"
                
                if let top = purchase.top, let buyer = purchase.buyer {
                    let csvLine = "\(top),\(buyer),\(total),\(itemsnum)\n"
                    csvString.append(csvLine)
                }
                
                let allUnformattedItems = String(purchase.items!).split(separator: ";")
                for item in allUnformattedItems{
                    let oneUnformattedItem = item.split(separator: ",")
                    let csvLine = "\(oneUnformattedItem[0]),\(oneUnformattedItem[1]),\(oneUnformattedItem[2]),\(oneUnformattedItem[3])\n"
                    csvString.append(csvLine)
                }
            }
        }
        
        return csvString
    }

    private func saveCSVFile() throws -> URL {
        let csvContent = createCSVContent()
        let fileManager = FileManager.default
        let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentDirectory.appendingPathComponent("Purchase.csv")
        
        do {
            try csvContent.write(to: fileURL, atomically: true, encoding: .utf8)
            return fileURL
        } catch {
            throw error
        }
    }
}


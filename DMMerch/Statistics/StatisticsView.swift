//
//  StatisticsView.swift
//  DMMerch
//
//  Created by Sean Laughlin on 3/24/23.
//

import SwiftUI
import CoreData
import Foundation
import Charts

struct StatisticsView: View {
    @Environment(\.managedObjectContext) var viewContext
    @FetchRequest(sortDescriptors: [], animation: .default) var items: FetchedResults<Item>
    @FetchRequest(sortDescriptors: [], animation: .default) var purchases: FetchedResults<Purchase>
    @FetchRequest(sortDescriptors: [SortDescriptor(\.typeCount, order: .reverse)], animation: .default) var types: FetchedResults<ItemType>
    
    @State var totalItemsPurch = 0
    @State var sortedItems: [Item] = []
    @State var sortedPurchases: [Purchase] = []
    
    var hexColors = readColors()
    
    @State var csvFileURL = URL(string: "www.seanwlaughlin.com")
    
    @State private var showingCSVExport = false
    
    var body: some View {
        Text("Performance Overview")
            .font(.title)
            .fontDesign(.rounded)
            .fontWeight(.bold)
            .padding(.leading)
            .frame(maxWidth: .infinity, alignment: .leading)
        
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.white)
                    .frame(width: 500, height: 175)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color(hex: findHex(color: "Pastel Orange", hexColors: hexColors)) ?? .black, lineWidth: 1)
                    )
                    .overlay(
                        VStack(alignment: .leading) {
                            HStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color(hex: findHex(color: "Pastel Blue", hexColors: hexColors)) ?? .black)
                                    .overlay(
                                        VStack {
                                            Text("Total Orders")
                                            Text("\(purchases.count)")
                                        }
                                        .foregroundColor(.black)
                                    )
                                    .frame(width: 150, height: 75)
                                    .padding(.leading)
                                
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color(hex: findHex(color: "Pastel Green", hexColors: hexColors)) ?? .black)
                                    .overlay(
                                        VStack {
                                            Text("Items Sold")
                                            Text("\(totalItemsPurch)")
                                        }
                                        .foregroundColor(.black)
                                    )
                                    .frame(width: 150, height: 75)
                                
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color(hex: findHex(color: "Pastel Purple", hexColors: hexColors)) ?? .black)
                                    .overlay(
                                        VStack {
                                            Text("Items Sold")
                                            Text("\(totalItemsPurch)")
                                        }
                                        .foregroundColor(.black)
                                    )
                                    .frame(width: 150, height: 75)
                            }
                            .frame(width: 500, alignment: .leading)
                            .padding(.top)
                            
                            ScrollView(.horizontal){
                                HStack{
                                    Spacer()
                                    ForEach(types) { type in
                                        VStack {
                                            Text(type.name!)
                                                .font(.system(size: 15))
                                                .fontDesign(.rounded)
                                                .foregroundColor(Color(hex: findHex(color: "Gray", hexColors: hexColors))!)
                                            Text("\(type.typeSales)")
                                                .font(.system(size: 20))
                                                .fontDesign(.rounded)
                                                .foregroundColor(Color(hex: findHex(color: "Black", hexColors: hexColors))!)
                                        }
                                    }
                                    Spacer()
                                }
                                .frame(height: 80, alignment: .center)
                            }
                        }
                    )
                
                Spacer()
                
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.white)
                    .frame(width: 500, height: 225)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color(hex: findHex(color: "Pastel Orange", hexColors: hexColors)) ?? .black, lineWidth: 1)
                    )
                    .overlay(
                        VStack(alignment: .leading) {
                            Spacer()
                            Text("Sales Over Time")
                                .font(.title2)
                                .fontWeight(.medium)
                                .fontDesign(.rounded)
                                .padding(.leading)
                                .frame(width: 500, height: 25, alignment: .leading)
                            Spacer()
                            HStack {
                                Spacer()
                                Chart{
                                    ForEach(sortedPurchases) { purchase in
                                        LineMark(
                                            x: .value("date", purchase.top!, unit: .day),
                                            y: .value("totalPrice", purchase.totalPrice)
                                        )
                                    }
                                }
                                .frame(width: 475, height: 150)
                                Spacer()
                            }
                            Spacer()
                        }
                    )
                
                Spacer()
                
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.white)
                    .frame(width: 500, height: 250)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color(hex: findHex(color: "Pastel Orange", hexColors: hexColors)) ?? .black, lineWidth: 1)
                    )
                    .overlay(
                        VStack(alignment: .leading) {
                            Spacer()
                            Text("Best Selling Items")
                                .font(.title2)
                                .fontWeight(.medium)
                                .fontDesign(.rounded)
                                .padding(.leading)
                                .frame(width: 500, height: 25, alignment: .leading)
                            Spacer()
                            HStack {
                                Text("Item Price")
                                    .fontWeight(.medium)
                                    .frame(width: 100, alignment: .center)
                                Text("Item Name & Type")
                                    .fontWeight(.medium)
                                    .frame(width: 230, alignment: .leading)
                                Text("Amount Sold")
                                    .fontWeight(.medium)
                                    .frame(width: 120, alignment: .center)
                            }
                            .padding(.leading)  
                            .frame(width: 475, height: 25)
                            Spacer()
                            ScrollView {
                                VStack(alignment: .leading) {
                                    ForEach(sortedItems) { item in
                                        if item.sold > 0 {
                                            HStack() {
                                                ZStack {
                                                    Circle()
                                                        .foregroundColor(Color(hex: findHex(color: "Pastel Orange", hexColors: hexColors))!)
                                                        .frame(width: 40, height: 40)
                                                    Text("$\(item.price)")
                                                        .foregroundColor(.white)
                                                }
                                                .frame(width: 100, alignment: .center)
                                                
                                                VStack(alignment: .leading) {
                                                    Text(item.name!)
                                                    Text(item.type!)
                                                        .font(.caption)
                                                        .foregroundColor(.gray)
                                                    
                                                }
                                                .frame(width: 230, alignment: .leading)
                                                
                                                Text("\(item.sold)")
                                                    .font(.system(size: 20))
                                                    .frame(width: 120, alignment: .center)
                                            }
                                        }
                                    }
                                }
                            }
                            .frame(width: 475, height: 150, alignment: .leading)
                            .padding(.leading)
                            
                            Spacer()
                        }
                    )
                
                Spacer()
            }
            .frame(width: 500, alignment: .leading)
            .padding(.leading)
            .padding(.trailing)
            
            VStack {
                Text("Amount Sold by Item Type")
                    .font(.title2)
                    .fontWeight(.medium)
                    .fontDesign(.rounded)
                
                Circle()
                    .fill(Color.white)
                    .overlay(
                        Circle()
                            .stroke(Color(hex: findHex(color: "Pastel Orange", hexColors: hexColors))!)
                    )
                    .frame(width: 300, height: 300)
                
                Chart(items, id: \.name) { item in
                    BarMark(
                        x: .value("sold", item.sold),
                        stacking: .normalized
                    )
                    .foregroundStyle(by: .value("type", item.type!))
                }
                .frame(width: 300, height: 75)
                
                Spacer()
                
                Button(action: {
                    showingCSVExport.toggle()
                }) {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(hex: findHex(color: "Pastel Orange", hexColors: hexColors))!)
                        .frame(width: 250, height: 100)
                        .overlay(
                            VStack {
                                Text("Export Data")
                                    .font(.title2)
                                    .fontWeight(.medium)
                                    .fontDesign(.rounded)
                                    .foregroundColor(.white)
                            }
                        )
                }
                Spacer()
            }
            .frame(width: 300)
        }
        .onAppear(perform: {
            sortedItems = items.sorted(by: { $0.sold > $1.sold })
            sortedPurchases = purchases.sorted(by: { $0.top! < $1.top! })
            
            for purchase in sortedPurchases {
                totalItemsPurch += Int(purchase.totalItems)
            }
            
        })
        .padding()
        .sheet(isPresented: $showingCSVExport) {
            ExportCSV(sortedPurchases: sortedPurchases).preferredColorScheme(.light)
        }
    }
}

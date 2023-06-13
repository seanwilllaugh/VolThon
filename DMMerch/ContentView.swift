//
//  ContentView.swift
//  DMMerch
//
//  Created by Sean Laughlin on 2/16/23.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) var viewContext
    @FetchRequest(sortDescriptors: [], animation: .default) var items: FetchedResults<Item>
    @FetchRequest(sortDescriptors: [], animation: .default) var purchases: FetchedResults<Purchase>
    
    @State private var shwoingAddScreen = false
    
    @State var Total      = 0
    @State var cashTotal  = 0
    @State var venmoTotal = 0
    
    let hexColors = readColors()
    
    func deleteItem(at offsets: IndexSet) {
        for offset in offsets {
            let item = items[offset]
            
            viewContext.delete(item)
        }
        
        try? viewContext.save()
    }
    
    var body: some View {
        NavigationSplitView{
            Image("OrgName")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(.leading)
                .padding(.trailing)
            VStack {
                Text("Total: $\(Total)")
                    .font(.largeTitle)
                    .padding(.bottom)
                    .offset(y:-20)
                
                HStack{
                    Spacer()
                    Circle()
                        .foregroundColor(.green)
                        .frame(width: 20, height: 20)
                    Text("Cash: $\(cashTotal)")
                    Spacer()
                    Circle()
                        .foregroundColor(.blue)
                        .frame(width: 20, height: 20)
                    Text("Venmo: $\(venmoTotal)")
                    Spacer()
                }
                //.padding(.bottom, 20.0)
                .offset(y:-20)
                
                NavigationLink{
                    NewPurchaseView().preferredColorScheme(.light)
                } label: {
                    Text("New Purchase")
                        .fixedSize()
                        .fontWeight(.semibold)
                        .foregroundColor(Color.white)
                        .frame(width: 300, height:100)
                        .background(Rectangle())
                        .foregroundColor(Color(hex: findHex(color: "Pastel Orange", hexColors: hexColors))!)
                        .cornerRadius(15)
                }
                .padding(.bottom, 20.0)
                .shadow(color: Color(hex: findHex(color: "Pastel Orange", hexColors: hexColors))!, radius: 5)
                
                NavigationLink{
                    InventoryView().preferredColorScheme(.light)
                } label:{
                    Text("Inventory")
                        .fixedSize()
                        .fontWeight(.semibold)
                        .foregroundColor(Color.white)
                        .frame(width: 300, height:100)
                        .background(Rectangle())
                        .foregroundColor(Color(hex: findHex(color: "Pastel Orange", hexColors: hexColors))!)
                        .cornerRadius(15)
                }
                .padding(.bottom, 20.0)
                .shadow(color: Color(hex: findHex(color: "Pastel Orange", hexColors: hexColors))!, radius: 5)
                
                NavigationLink{
                    TransactionsView().preferredColorScheme(.light)
                } label:{
                    Text("Recent Transactions")
                        .fixedSize()
                        .fontWeight(.semibold)
                        .foregroundColor(Color.white)
                        .frame(width: 300, height:100)
                        .background(Rectangle())
                        .foregroundColor(Color(hex: findHex(color: "Pastel Orange", hexColors: hexColors))!)
                        .cornerRadius(15)
                }
                .padding(.bottom, 20.0)
                .shadow(color: Color(hex: findHex(color: "Pastel Orange", hexColors: hexColors))!, radius: 5)
                
                
                Spacer()
                
                ZStack{
                    Image("Logo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(.bottom)
                    
                    HStack{
                        NavigationLink{
                            StatisticsView().preferredColorScheme(.light)
                        } label:{
                            Image(systemName: "chart.xyaxis.line")
                                .fixedSize()
                                .fontWeight(.semibold)
                                .foregroundColor(Color.white)
                                .frame(width: 80, height: 80)
                                .background(Circle())
                                .foregroundColor(Color(hex: findHex(color: "Pastel Orange", hexColors: hexColors))!)
                                .cornerRadius(15)
                        }
                        .padding(.bottom, 20.0)
                        .padding(.leading)
                        .shadow(color: Color(hex: findHex(color: "Pastel Orange", hexColors: hexColors))!, radius: 5)
                        
                        Spacer()
                    }
                }
            }
            .offset(y: 30)
            .onAppear(perform: {
                
                Total      = 0
                cashTotal  = 0
                venmoTotal = 0
                
                for purchase in purchases{
                    if(purchase.method == "Cash")
                    {
                        cashTotal += Int(purchase.totalPrice)
                    }
                    
                    if(purchase.method == "Venmo")
                    {
                        venmoTotal += Int(purchase.totalPrice)
                    }
                    
                    Total = cashTotal + venmoTotal
                }
            })
        } detail: {
            NavigationStack{
                TransactionsView().preferredColorScheme(.light)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

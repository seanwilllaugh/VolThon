//
//  InventoryView.swift
//  DMMerch
//
//  Created by Sean Laughlin on 2/18/23.
//

import SwiftUI

struct InventoryView: View {
    @Environment(\.managedObjectContext) var viewContext
    @FetchRequest(sortDescriptors: [], animation: .default) var items: FetchedResults<Item>
    @FetchRequest(sortDescriptors: [SortDescriptor(\.typeCount, order: .reverse)], animation: .default) var types: FetchedResults<ItemType>
    
    var hexColors = readColors()
    
    @State private var showingAddScreen  = false
    @State private var showingFilters    = false
    @State private var showingTypeScreen = false
    
    @State var filter = ""
    @State private var searchText = ""
    
    func deleteItem(at offsets: IndexSet) {
        for offset in offsets {
            let item = items[offset]
            
            viewContext.delete(item)
        }
        try? viewContext.save()
    }
    
    var filteredItems: [Item] {
        if searchText.isEmpty {
            return Array(items)
        } else {
            return items.filter { $0.name!.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    var body: some View {
        HStack{
            VStack{
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(Color(hex: findHex(color: "Gray", hexColors: hexColors))!)
                    .frame(width: 200, height: 325)
                    .overlay(
                        VStack{
                            HStack(alignment: .center){
                                Text("Item Type")
                                    .font(Font.custom("LeagueSpartan-Bold", size: 24))
                                    .padding(.leading, 10)
                                
                                Spacer()
                                
                                Button{
                                    showingTypeScreen.toggle()
                                } label:{
                                    Image(systemName: "rectangle.and.pencil.and.ellipsis")
                                        .resizable()
                                        .frame(width: 30, height: 25)
                                }
                                .offset(y: -5)
                                .padding(.trailing, 10)
                                    
                            }
                            .padding(.top, 10)
                            
                            Spacer()
                            
                            Button{
                                filter = ""
                            }label:{
                                RoundedRectangle(cornerRadius: 10)
                                    .frame(width: 140, height: 30)
                                    .foregroundColor(Color(hex: findHex(color: "Pastel Orange", hexColors: hexColors))!)
                                    .overlay(
                                        Text("Clear Filters")
                                            .font(Font.custom("LeagueSpartan-Bold", size: 20))
                                            .foregroundColor(.white)
                                    )
                            }
                            
                            Spacer()
                            
                            ScrollView{
                                VStack{
                                    ForEach(types, id: \.self){ type in
                                        Button{
                                            filter = type.name!
                                        } label: {
                                            RoundedRectangle(cornerRadius: 10)
                                                .frame(width: 190, height: 45)
                                                .foregroundColor(Color(hex: findHex(color: "Pastel Orange", hexColors: hexColors))!)
                                                .overlay(
                                                    Text(type.name!)
                                                        .font(Font.custom("LeagueSpartan-Bold", size: 24))
                                                        .foregroundColor(.white)
                                                )
                                        }
                                    }
                                }
                            }
                            
                            Spacer()
                        }
                    )
                
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(Color(hex: findHex(color: "Gray", hexColors: hexColors))!)
                    .frame(width: 200, height: 325)
                    .overlay(
                        VStack{
                            HStack{
                                Text("Low Stock")
                                    .font(Font.custom("LeagueSpartan-Bold", size: 24))
                                    .padding(.leading, 10)
                                    
                                Spacer()
                            }
                            .padding(.top, 10)
                            
                            Spacer()
                        }
                    )
                
                Spacer()
            }
            .padding(.leading)
            
            Spacer()
            
            VStack(alignment: .leading){
                ScrollView{
                    if(searchText.isEmpty){
                        if(filter != ""){
                            Text(filter)
                                .font(Font.custom("LeagueSpartan-Bold", size: 24))
                                .foregroundColor(.black)
                                .padding(.leading)
                            
                            ForEach(types, id: \.self){ type in
                                if(filter == type.name!){
                                    let typeItems = items.filter{$0.type == filter}
                                                                 
                                    ScrollView(.horizontal){
                                        HStack{
                                            ForEach(typeItems){ item in
                                                InventoryCard(item: item)
                                                    .padding(.trailing, 5)
                                            }
                                        }
                                    }
                                }
                            }
                            .padding(.leading)
                        }else{
                            
                            ForEach(types, id: \.self){ type in
                                HStack{
                                    Text(type.name!)
                                        .font(Font.custom("LeagueSpartan-Bold", size: 24))
                                        .foregroundColor(.black)
                                        .padding(.leading)
                                    
                                    Spacer()
                                }
                                .padding(.bottom, 10)
                                
                                let typeItems = items.filter{$0.type == type.name!}
                                
                                ScrollView(.horizontal){
                                    HStack{
                                        ForEach(typeItems){ item in
                                            InventoryCard(item: item)
                                                .padding(.trailing, 5)
                                        }
                                    }
                                }
                            }
                            .padding(.leading)
                        }
                    }else{
                        ForEach(filteredItems){ item in
                            InventoryCard(item: item)
                                .padding(.trailing, 5)
                        }
                    }
                }
            }
            
            Spacer()
        }
        .onAppear(perform: {
            
        })
        .padding(.top)
        .navigationTitle("Inventory").font(Font.custom("LeagueSpartan-Bold", size: 42))
        .toolbar{
            ToolbarItem() {
                Button{
                    showingAddScreen.toggle()
                } label: {
                    Label("Add Item", systemImage: "plus")
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Rectangle()
                    .frame(width: 250, height: 30)
                    .foregroundColor(Color(hex: findHex(color: "White Smoke", hexColors: hexColors)))
                    .cornerRadius(15)
                    .overlay(
                        ZStack{
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color(hex: findHex(color: "Other Gray", hexColors: hexColors))!, lineWidth: 1)
                            
                            TextField("Search", text: $searchText)
                                .frame(height: 25)
                                .textFieldStyle(PlainTextFieldStyle())
                                .background(Color(hex: findHex(color: "White Smoke", hexColors: hexColors))!)
                                .cornerRadius(15)
                                .padding(.horizontal)
                        }
                    )
            }
        }
        .sheet(isPresented: $showingAddScreen) {
            AddItemView().preferredColorScheme(.light)
        }
        .sheet(isPresented: $showingTypeScreen) {
            TypesView()
        }
    }
}

struct InventoryView_Previews: PreviewProvider {
    static var previews: some View {
        InventoryView()
    }
}

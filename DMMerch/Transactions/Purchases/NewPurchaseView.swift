//
//  NewPurchaseView.swift
//  DMMerch
//
//  Created by Sean Laughlin on 2/18/23.
//

import SwiftUI

struct NewPurchaseView: View {
    @Environment(\.managedObjectContext) var viewContext
    @FetchRequest(sortDescriptors: [], animation: .default) var items: FetchedResults<Item>
    @FetchRequest(sortDescriptors: [SortDescriptor(\.typeCount, order: .reverse)], animation: .default) var types: FetchedResults<ItemType>
    
    var hexColors = readColors()
    
    @State private var blurScale = 0.0
    
    @State private var showingCompleteScreen = false
    
    @State var Cart = [cartItem]()
    @State private var showingAddScreen = false
    @State private var showingFilters   = false
    
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
        ZStack{
            HStack{
                VStack{
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(Color(hex: findHex(color: "Gray", hexColors: hexColors))!)
                        .frame(width: 200, height: 325)
                        .overlay(
                            VStack{
                                HStack{
                                    Text("Item Type")
                                        .font(Font.custom("LeagueSpartan-Bold", size: 24))
                                        .padding(.leading, 10)
                                    
                                    Spacer()
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
                                    Text("Cart")
                                        .font(Font.custom("LeagueSpartan-Bold", size: 24))
                                        .padding(.leading, 10)
                                    
                                    Spacer()
                                }
                                .padding(.top, 10)
                                
                                ScrollView{
                                    VStack{
                                        ForEach(Cart.indices, id: \.self) { index in
                                            let item = Cart[index]
                                            
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(Color(hex: findHex(color: "Pastel Orange", hexColors: hexColors))!, lineWidth: 1)
                                                .frame(width: 190, height: 30)
                                                .overlay(
                                                    HStack{
                                                        Text("\(item.itemQuantity ?? 0)")
                                                            .font(Font.custom("LeagueSpartan-Bold", size: 14))
                                                            .foregroundColor(.black)
                                                            .padding(.leading, 10)
                                                            .frame(width: 20)
                                                        
                                                        VStack(alignment: .leading){
                                                            HStack{
                                                                Circle()
                                                                    .frame(width: 5, height: 5)
                                                                    .foregroundColor(Color(hex: findHex(color: item.itemColor!, hexColors: hexColors)) ?? .black)
                                                                
                                                                Text(item.itemName ?? "N/A")
                                                                    .font(Font.custom("LeagueSpartan-Bold", size: 9))
                                                                    .padding(.leading, -7)
                                                                Spacer()
                                                            }
                                                            
                                                            Text(item.itemType ?? "N/A")
                                                                .font(Font.custom("LeagueSpartan-Bold", size: 7))
                                                                .foregroundColor(.gray)
                                                                .padding(.top, -7)
                                                        }
                                                        .frame(width: 70)
                                                        Text(item.itemSize!)
                                                            .font(Font.custom("LeagueSpartan-Bold", size: 10))
                                                            .frame(width: 25)
                                                        
                                                        
                                                        Text("$\(item.itemPrice ?? 0)")
                                                            .font(Font.custom("LeagueSpartan-Bold", size: 10))
                                                            .frame(width: 25)
                                                            .padding(0)
                                                        
                                                        
                                                        Button{
                                                            Cart.remove(at: index)
                                                        } label:{
                                                            Image(systemName: "trash.square.fill")
                                                                .resizable()
                                                                .frame(width: 15, height: 15)
                                                                .foregroundColor(Color(hex: findHex(color: "Pastel Orange", hexColors: hexColors))!)
                                                        }
                                                        
                                                        Spacer()
                                                    }
                                                        .frame(width: 185)
                                                )
                                        }
                                    }
                                }
                                
                                Button{
                                    showingCompleteScreen.toggle()
                                    blurScale = 5
                                } label:{
                                    RoundedRectangle(cornerRadius: 10)
                                        .foregroundColor(Color(hex: findHex(color: "Pastel Orange", hexColors: hexColors))!)
                                        .frame(width: 190, height: 60)
                                        .overlay(
                                            ZStack{
                                                RoundedRectangle(cornerRadius: 10)
                                                    .stroke(.white, lineWidth: 2)
                                                    .frame(width: 190, height: 60)
                                                
                                                Text("Checkout")
                                                    .font(Font.custom("LeagueSpartan-Bold", size: 32))
                                                    .foregroundColor(.white)
                                            }
                                        )
                                }
                                .padding(.bottom, 5)
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
                                                    PurchaseCard(item: item, Cart: $Cart)
                                                        .padding(.trailing, 5)
                                                }
                                            }
                                        }
                                        .padding(.leading)
                                    }
                                }
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
                                                PurchaseCard(item: item, Cart: $Cart)
                                                    .padding(.trailing, 5)
                                            }
                                        }
                                    }
                                }
                                .padding(.leading)
                            }
                        }else{
                            ForEach(filteredItems){ item in
                                PurchaseCard(item: item, Cart: $Cart)
                                    .padding(.trailing, 5)
                            }
                        }
                    }
                }
                
                Spacer()
            }
            .padding(.top)
            .navigationTitle("New Purchase").font(Font.custom("LeagueSpartan-Bold", size: 42))
            .toolbar{
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
            .blur(radius: blurScale)
            
            if(showingCompleteScreen){
                ZStack{
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.white)
                        .frame(width: 750, height: 700)
                    CompletePurchase(Cart: $Cart, blurScale: $blurScale, showingCompleteScreen: $showingCompleteScreen).preferredColorScheme(.light)
                }
            }
        }
    }
}

struct NewPurchaseView_Previews: PreviewProvider {
    static var previews: some View {
        NewPurchaseView()
    }
}

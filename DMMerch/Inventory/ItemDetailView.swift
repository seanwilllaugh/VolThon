//
//  ItemDetailView.swift
//  DMMerch
//
//  Created by Sean Laughlin on 7/24/23.
//

import SwiftUI
import CoreData
import Foundation
import Charts

struct ItemDetailView: View {
    @Environment(\.managedObjectContext) var viewContext
    @Environment(\.dismiss) var dismiss
    @FetchRequest(sortDescriptors: [SortDescriptor(\.typeCount, order: .reverse)], animation: .default) var types: FetchedResults<ItemType>
    @FetchRequest(sortDescriptors: [SortDescriptor(\.top)], animation: .default) var purchases: FetchedResults<Purchase>
    
    @State var cell  = ["0", "1"]
    
    @State private var showingDeleteAlert = false
    @State private var showingEditScreen = false
    
    @State var editingInventory   = false
    @State var editingOrders      = false
    @State var editingDiscontinue = false
    @State var editingTags        = false
    
    @State var filteredPurchases = [Purchase]()
    
    let item: Item
    @State var image  = UIImage()
    
    let hexColors = readColors()
    
    func deleteBook() {
        for type in types{
            if(item.type == type.name){
                type.typeCount = type.typeCount - 1
                break
            }
        }
        
        viewContext.delete(item)
        
        dismiss()
        
        try? viewContext.save() // uncomment this line to make the deletion permanent
    }
    
    func loadImage()->UIImage{
        guard UIImage(data: item.image!) != nil else{
            return UIImage(imageLiteralResourceName: "FTKShirt")
        }
        
        return UIImage(data: item.image!)!
    }
    
    var body: some View {
        ZStack{
            HStack{
                
                /* Title, picture, colors/sizes */
                VStack(alignment: .leading){
                    
                    /* Title */
                    Text("\(item.name ?? "N/A")")
                        .font(Font.custom("LeagueSpartan-Bold", size: 60))
                    Text("\(item.type ?? "N/A")")
                        .font(Font.custom("LeagueSpartan-Bold", size: 40))
                        .foregroundColor(.gray)
                    
                    
                    Spacer()
                    
                    /* Image */
                    Image(uiImage: image)
                        .resizable()
                        .frame(width: 350, height: 400)
                        .cornerRadius(20)
                    
                    Spacer()
                    
                    /* Colors and Sizes */
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color(hex: findHex(color: "Pastel Orange", hexColors: hexColors)) ?? .black, lineWidth: 2)
                        .frame(width: 350, height: 250)
                        .foregroundColor(.clear)
                        .overlay(
                            VStack(alignment: .leading){
                                Text("Colors")
                                    .font(Font.custom("LeagueSpartan-Bold", size: 36))
                                    .padding(.top)
                                    .padding(.leading, 5)
                                
                                HStack{
                                    ForEach(item.colorArray){ color in
                                        Circle()
                                            .frame(width: 50, height: 50)
                                            .foregroundColor(Color(hex: findHex(color: color.colorName!, hexColors: hexColors))!)
                                    }
                                    
                                    Spacer()
                                }
                                .padding(.leading, 5)
                                
                                Spacer()
                                
                                Text("Sizes")
                                    .font(Font.custom("LeagueSpartan-Bold", size: 36))
                                    .padding(.leading, 5)
                                
                                HStack{
                                    if let firstColor = item.colorArray.first {
                                        ForEach(firstColor.sizeArray){ size in
                                            RoundedRectangle(cornerRadius: 5)
                                                .frame(width: 45, height: 45)
                                                .foregroundColor(Color(hex: findHex(color: "Pastel Gray", hexColors: hexColors))!)
                                                .overlay(
                                                    Text(size.sizeName!)
                                                        .font(Font.custom("LeagueSpartan", size: 14))
                                                )
                                        }
                                    }
                                    
                                    Spacer()
                                }
                                .padding(.leading, 5)
                                
                                Spacer()
                            }
                                .frame(width: 350, alignment: .leading)
                                .padding(.leading)
                        )
                    
                }
                .padding(.leading)
                
                
                /* HStack with 2 VStacks and Stats */
                VStack(){
                    Spacer()
                    
                    /* Holds Inventory and VStack for Price, Tags, Order Info, and Discontinued */
                    HStack{
                        /* Inventory */
                        VStack{
                            Spacer()
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color(hex: findHex(color: "Pastel Orange", hexColors: hexColors))!, lineWidth: 2)
                                .frame(width: 450, height: 400)
                                .padding(.leading)
                                .overlay(
                                    VStack{
                                        HStack{
                                            Text("Inventory")
                                                .font(Font.custom("LeagueSpartan-Bold", size: 40))
                                                .padding(.leading)
                                                .padding(.top)
                                            
                                            Spacer()
                                            
                                            RoundedRectangle(cornerRadius: 10)
                                                .foregroundColor(Color(hex: findHex(color: "Pastel Orange", hexColors: hexColors))!)
                                                .opacity(0.1)
                                                .frame(width: 100, height: 40)
                                                .padding(.trailing)
                                                .padding(.top, 12)
                                                .overlay(
                                                    ZStack{
                                                        Button{
                                                            editingInventory = true
                                                        } label: {
                                                            RoundedRectangle(cornerRadius: 10)
                                                                .stroke(Color(hex: findHex(color: "Pastel Orange", hexColors: hexColors))!, lineWidth: 2)
                                                                .frame(width: 100, height: 40)
                                                                .padding(.trailing)
                                                                .padding(.top, 12)
                                                                .overlay(
                                                                    Text("Edit")
                                                                        .font(Font.custom("LeagueSpartan", size: 22))
                                                                        .padding(.top, 10)
                                                                        .padding(.trailing)
                                                                )
                                                        }
                                                        Spacer()
                                                    }
                                                )
                                        }
                                        
                                        HStack{
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(Color(hex: findHex(color: "Pastel Orange", hexColors: hexColors))!, lineWidth: 2)
                                                .frame(width: 100, height: 40)
                                                .overlay(
                                                    ZStack{
                                                        RoundedRectangle(cornerRadius: 10)
                                                            .fill(Color(hex: findHex(color: "Pastel Orange", hexColors: hexColors))!)
                                                            .opacity(0.1)
                                                        Text("Total: \(countInventoryTotal(item: item))")
                                                            .font(Font.custom("LeagueSpartan", size: 18))
                                                    }
                                                )
                                                .padding(.leading)
                                            Spacer()
                                        }
                                        .padding(.top, -9)
                                        
                                        Spacer()
                                        
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(Color(hex: findHex(color: "Pastel Orange", hexColors: hexColors))!, lineWidth: 2)
                                            .frame(width: 420, height: 270)
                                            .overlay(
                                                ZStack{
                                                    if(editingInventory){
                                                        EditingInventory(item: item, editingInventory: $editingInventory)
                                                    }else{
                                                        RoundedRectangle(cornerRadius: 20)
                                                            .fill(Color(hex: findHex(color: "Pastel Orange", hexColors: hexColors))!)
                                                            .opacity(0.1)
                                                        VStack(alignment:.leading){
                                                            Grid{
                                                                GridRow{
                                                                    Text("Color")
                                                                        .font(Font.custom("LeagueSpartan-Bold", size: 22))
                                                                        .padding(.trailing, 7)
                                                                    
                                                                    if let firstColor = item.colorArray.first{
                                                                        ForEach(firstColor.sizeArray){ size in
                                                                            RoundedRectangle(cornerRadius: 5)
                                                                                .frame(width: 45, height: 45)
                                                                                .foregroundColor(Color(hex: findHex(color: "Pastel Gray", hexColors: hexColors))!)
                                                                                .overlay(
                                                                                    Text(size.sizeName!)
                                                                                        .font(Font.custom("LeagueSpartan-Bold", size: 18))
                                                                                )
                                                                        }
                                                                    }
                                                                }
                                                                
                                                                
                                                                ForEach(item.colorArray){ color in
                                                                    GridRow{
                                                                        Circle()
                                                                            .frame(width: 45, height: 45)
                                                                            .foregroundColor(Color(hex: findHex(color: color.colorName!, hexColors: hexColors))!)
                                                                            .padding(.trailing)
                                                                        
                                                                        ForEach(color.sizeArray){ size in
                                                                            Text("\(size.inventory)")
                                                                                .font(Font.custom("LeagueSpartan", size: 30))
                                                                        }
                                                                    }
                                                                }
                                                            }
                                                            .padding(.top)
                                                            
                                                            Spacer()
                                                        }
                                                    }
                                                }
                                            )
                                        
                                        Spacer()
                                    }
                                        .frame(width: 450, alignment: .leading)
                                        .padding(.leading)
                                )
                        }
                        
                        Spacer()
                        
                        /* Price, Tags, Order Info, and Discontinued */
                        VStack{
                            HStack{
                                Spacer()
                                
                                /* Price */
                                ZStack{
                                    Circle()
                                        .frame(width: 100, height: 100)
                                        .foregroundColor(Color(hex: findHex(color: "Pastel Orange", hexColors: hexColors))!)
                                    Text("$\(item.price)")
                                        .font(Font.custom("LeagueSpartan-Bold", size: 40))
                                        .foregroundColor(.white)
                                        .padding(.top, 7)
                                }
                            }
                            
                            Spacer()
                            
                            /* Tags */
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color(hex: findHex(color: "Pastel Orange", hexColors: hexColors))!, lineWidth: 2)
                                .frame(width: 300, height: 100)
                                .overlay(
                                    VStack{
                                        HStack{
                                            Text("Tags")
                                                .font(Font.custom("LeagueSpartan-Bold", size: 36))
                                                .padding(.top, 10)
                                                .padding(.leading, 5)
                                            
                                            Spacer()
                                            
                                            Button{
                                                editingTags = true
                                            } label: {
                                                ZStack{
                                                    RoundedRectangle(cornerRadius: 10)
                                                        .fill(Color(hex: findHex(color: "Pastel Orange", hexColors: hexColors))!)
                                                        .opacity(0.1)
                                                        .frame(width: 60, height: 30)
                                                        .overlay(
                                                            RoundedRectangle(cornerRadius: 10)
                                                                .stroke(Color(hex: findHex(color: "Pastel Orange", hexColors: hexColors))!, lineWidth: 2)
                                                                .frame(width: 60, height: 30)
                                                        )
                                                    
                                                    Text("Edit")
                                                        .font(Font.custom("LeagueSpartan", size: 16))
                                                }
                                            }
                                            .padding(.trailing, 25)
                                        }
                                        
                                        Spacer()
                                        
                                        HStack{
                                            if(item.tag! != "None"){
                                                let tags = item.tag!.split(separator: ",")
                                                
                                                ForEach(tags, id: \.self){ tag in
                                                    if(tag != "None"){
                                                        Text(tag)
                                                            .font(Font.custom("LeagueSpartan", size: 20))
                                                    }
                                                }
                                            }else{
                                                Text(item.tag ?? "N/A")
                                                    .font(Font.custom("LeagueSpartan", size: 20))
                                            }
                                        }
                                        .padding(.bottom)
                                        .padding(.trailing)
                                        
                                        Spacer()
                                    }
                                        .frame(width: 300, alignment: .leading)
                                        .padding(.leading)
                                )
                            
                            /* Order Info */
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color(hex: findHex(color: "Pastel Orange", hexColors: hexColors))!, lineWidth: 2)
                                .frame(width: 300, height: 150)
                                .overlay(
                                    HStack{
                                        VStack(alignment: .leading){
                                            HStack{
                                                Text("Order Info")
                                                    .font(Font.custom("LeagueSpartan-Bold", size: 36))
                                                    .padding(.top, 10)
                                                    .padding(.bottom,0.5)
                                                
                                                Spacer()
                                                
                                                Button{
                                                    editingOrders = true
                                                } label: {
                                                    ZStack{
                                                        RoundedRectangle(cornerRadius: 10)
                                                            .fill(Color(hex: findHex(color: "Pastel Orange", hexColors: hexColors))!)
                                                            .opacity(0.1)
                                                            .frame(width: 60, height: 30)
                                                            .overlay(
                                                                RoundedRectangle(cornerRadius: 10)
                                                                    .stroke(Color(hex: findHex(color: "Pastel Orange", hexColors: hexColors))!, lineWidth: 2)
                                                                    .frame(width: 60, height: 30)
                                                            )
                                                        
                                                        Text("Edit")
                                                            .font(Font.custom("LeagueSpartan", size: 16))
                                                    }
                                                }
                                                .padding(.trailing, 25)
                                            }
                                            
                                            HStack{
                                                Text("Last Ordered: ")
                                                    .font(Font.custom("LeagueSpartan", size: 20))
                                                
                                                if(item.lastOrderDate == nil){
                                                    Text("None")
                                                        .font(Font.custom("LeagueSpartan", size: 20))
                                                }else{
                                                    Text(item.lastOrderDate!, style: .date)
                                                        .font(Font.custom("LeagueSpartan", size: 20))
                                                }
                                            }
                                            .padding(.trailing)
                                            
                                            Spacer()
                                            
                                            HStack{
                                                Text("Stock Ordered: ")
                                                    .font(Font.custom("LeagueSpartan", size: 20))
                                                
                                                Text("\(item.lastOrderAmt)")
                                                    .font(Font.custom("LeagueSpartan", size: 20))
                                            }
                                            .padding(.trailing)
                                            
                                            Spacer()
                                            
                                            HStack{
                                                Text("Cost: ")
                                                    .font(Font.custom("LeagueSpartan", size: 20))
                                                
                                                Text("\(item.lastOrderCost)")
                                                    .font(Font.custom("LeagueSpartan", size: 20))
                                            }
                                            .padding(.trailing)
                                            
                                            Spacer()
                                        }
                                        .frame(width: 300, alignment: .leading)
                                        .padding(.leading, 25)
                                        
                                        
                                    }
                                        .frame(width: 300)
                                )
                            
                            /* Discontinued */
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color(hex: findHex(color: "Pastel Orange", hexColors: hexColors))!, lineWidth: 2)
                                .frame(width: 300, height: 100)
                                .overlay(
                                    VStack(alignment:.leading){
                                        
                                        HStack{
                                            if(item.discontinued){
                                                Text("Discontinued")
                                                    .font(Font.custom("LeagueSpartan-Bold", size: 36))
                                                    .padding(.top, 10)
                                                    .foregroundColor(.red)
                                            }else{
                                                Text("Discontinued")
                                                    .font(Font.custom("LeagueSpartan-Bold", size: 36))
                                                    .padding(.top, 10)
                                            }
                                            
                                            Spacer()
                                            
                                            Button{
                                                editingDiscontinue = true
                                            } label: {
                                                ZStack{
                                                    RoundedRectangle(cornerRadius: 10)
                                                        .fill(Color(hex: findHex(color: "Pastel Orange", hexColors: hexColors))!)
                                                        .opacity(0.1)
                                                        .frame(width: 60, height: 30)
                                                        .overlay(
                                                            RoundedRectangle(cornerRadius: 10)
                                                                .stroke(Color(hex: findHex(color: "Pastel Orange", hexColors: hexColors))!, lineWidth: 2)
                                                                .frame(width: 60, height: 30)
                                                        )
                                                    
                                                    Text("Edit")
                                                        .font(Font.custom("LeagueSpartan", size: 16))
                                                }
                                            }
                                            .padding(.trailing, 25)
                                        }
                                        
                                        Spacer()
                                        
                                        HStack{
                                            if(item.discontinued){
                                                Text("Disc. Date:")
                                                    .font(Font.custom("LeagueSpartan", size: 20))
                                                Text(item.discontinuedDate!, style: .date)
                                                    .font(Font.custom("LeagueSpartan", size: 20))
                                            }else{
                                                Text("Disc. Date: N/A")
                                                    .font(Font.custom("LeagueSpartan", size: 20))
                                            }
                                        }
                                        .padding(.bottom)
                                        
                                        Spacer()
                                    }
                                        .frame(width: 300, alignment: .leading)
                                        .padding(.leading,25)
                                )
                        }
                        .frame(width: 300)
                        .padding(.trailing)
                        
                    }
                    .padding(.bottom)
                    
                    /* Stats */
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color(hex: findHex(color: "Pastel Orange", hexColors: hexColors))!, lineWidth: 2)
                        .frame(height: 250)
                        .padding(.trailing)
                        .padding(.leading)
                        .overlay(
                            VStack{
                                HStack{
                                    Text("Statistics")
                                        .font(Font.custom("LeagueSpartan-Bold", size: 40))
                                        .padding(.top)
                                        .padding(.bottom, -5)
                                        .padding(.leading,5)
                                    
                                    Button{
                                        
                                    }label:{
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(Color(hex: findHex(color: "Pastel Orange", hexColors: hexColors))!)
                                            .opacity(0.1)
                                            .frame(width: 100, height: 30)
                                            .overlay(
                                                ZStack{
                                                    RoundedRectangle(cornerRadius: 10)
                                                        .stroke(Color(hex: findHex(color: "Pastel Orange", hexColors: hexColors))!, lineWidth: 2)
                                                    
                                                    Text("24 Hours")
                                                }
                                            )
                                            .padding(.top)
                                            .padding(.leading)
                                    }
                                    
                                    Button{
                                        
                                    }label:{
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(Color(hex: findHex(color: "Pastel Orange", hexColors: hexColors))!)
                                            .opacity(0.1)
                                            .frame(width: 100, height: 30)
                                            .overlay(
                                                ZStack{
                                                    RoundedRectangle(cornerRadius: 10)
                                                        .stroke(Color(hex: findHex(color: "Pastel Orange", hexColors: hexColors))!, lineWidth: 2)
                                                    
                                                    Text("7 Days")
                                                }
                                            )
                                            .padding(.top)
                                            .padding(.leading)
                                    }
                                    
                                    Button{
                                        
                                    }label:{
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(Color(hex: findHex(color: "Pastel Orange", hexColors: hexColors))!)
                                            .opacity(0.1)
                                            .frame(width: 100, height: 30)
                                            .overlay(
                                                ZStack{
                                                    RoundedRectangle(cornerRadius: 10)
                                                        .stroke(Color(hex: findHex(color: "Pastel Orange", hexColors: hexColors))!, lineWidth: 2)
                                                    
                                                    Text("Month")
                                                }
                                            )
                                            .padding(.top)
                                            .padding(.leading)
                                    }
                                    
                                    Spacer()
                                    
                                    Button{
                                        
                                    }label:{
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(Color(hex: findHex(color: "Pastel Orange", hexColors: hexColors))!)
                                            .opacity(0.1)
                                            .frame(width: 100, height: 30)
                                            .overlay(
                                                ZStack{
                                                    RoundedRectangle(cornerRadius: 10)
                                                        .stroke(Color(hex: findHex(color: "Pastel Orange", hexColors: hexColors))!, lineWidth: 2)
                                                    
                                                    Text("Custom")
                                                }
                                            )
                                            .padding(.top)
                                            .padding(.leading)
                                    }
                                    .padding(.trailing)
                                    
                                }
                                
                                HStack{
                                    ZStack{
                                        RoundedRectangle(cornerRadius: 20)
                                            .fill(Color(hex: findHex(color: "Pastel Orange", hexColors: hexColors)) ?? .black)
                                            .opacity(0.1)
                                            .frame(width: 550, height: 180)
                                            .padding(.bottom)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 20)
                                                    .stroke(Color(hex: findHex(color: "Pastel Orange", hexColors: hexColors))!, lineWidth: 2)
                                                    .frame(height: 180)
                                                    .padding(.bottom)
                                            )
                                        
                                        Chart{
                                            ForEach(filteredPurchases) { purchase in
                                                LineMark(
                                                    x: .value("date", purchase.top!, unit: .day),
                                                    y: .value("totalPrice", purchase.totalItems)
                                                )
                                            }
                                        }
                                        .frame(width: 520, height: 150)
                                    }
                                    
                                    Spacer()
                                    
                                    VStack{
                                        RoundedRectangle(cornerRadius: 20)
                                            .fill(Color(hex: findHex(color: "Pastel Orange", hexColors: hexColors)) ?? .black)
                                            .opacity(0.1)
                                            .frame(width: 200, height: 85)
                                            .overlay(
                                                ZStack{
                                                    RoundedRectangle(cornerRadius: 20)
                                                        .stroke(Color(hex: findHex(color: "Pastel Orange", hexColors: hexColors))!, lineWidth: 2)
                                                        .frame(height: 85)
                                                    
                                                    VStack{
                                                        Text("Total Sold")
                                                            .font(Font.custom("LeagueSpartan-Bold", size: 26))
                                                        Text(" \(item.sold)")
                                                            .font(Font.custom("LeagueSpartan", size: 26))
                                                    }
                                                    .padding(.trailing)
                                                }
                                            )
                                        
                                        RoundedRectangle(cornerRadius: 20)
                                            .fill(Color(hex: findHex(color: "Pastel Orange", hexColors: hexColors)) ?? .black)
                                            .opacity(0.1)
                                            .frame(width: 200, height: 85)
                                            .overlay(
                                                ZStack{
                                                    RoundedRectangle(cornerRadius: 20)
                                                        .stroke(Color(hex: findHex(color: "Pastel Orange", hexColors: hexColors))!, lineWidth: 2)
                                                        .frame(height: 85)
                                                    
                                                    VStack{
                                                        Text("Total Profit")
                                                            .font(Font.custom("LeagueSpartan-Bold", size: 26))
                                                        Text("$\(item.sold * item.price)")
                                                            .font(Font.custom("LeagueSpartan", size: 26))
                                                    }
                                                }
                                            )
                                    }
                                    .padding(.bottom)
                                }
                                
                                Spacer()
                            }
                                .frame(width: 750, alignment: .leading)
                        )
                }
                Spacer()
            }
            .navigationBarTitleDisplayMode(.inline)
            .onAppear(perform: {
                image = loadImage()
                filteredPurchases = findItemPurchases(itemName: item.name!, purchases: purchases)
            })
            .alert("Delete Item", isPresented: $showingDeleteAlert) {
                Button("Delete", role: .destructive, action: deleteBook)
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("Are you sure?")
            }
            .toolbar {
                Button {
                    showingDeleteAlert = true
                } label: {
                    Label("Delete this item", systemImage: "trash")
                }
                Button{
                    showingEditScreen.toggle()
                } label: {
                    Label("Edit Item", systemImage: "pencil")
                }
            }
            .sheet(isPresented: $showingEditScreen) {
                EditItemView(item : item).preferredColorScheme(.light)
            }
            
            if(editingOrders){
                EditOrders(item: item, editingOrders: $editingOrders)
                    .offset(y: -10)
                    .offset(x: 10)
            }
            
            if(editingDiscontinue){
                EditDiscontinued(item: item, editingDiscontinued: $editingDiscontinue)
            }
            
            if(editingTags){
                EditTags(item: item, editingTags: $editingTags)
            }
        }
    }
}

/*struct ItemDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ItemDetailView()
    }
}*/


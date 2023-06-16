//
//  CompletePurchaseView.swift
//  DMMerch
//
//  Created by Sean Laughlin on 2/20/23.
//

import SwiftUI
import Foundation

struct CompletePurchaseView: View {
    @Environment(\.managedObjectContext) var viewContext
    @Environment(\.dismiss) var dismiss
    @FetchRequest(sortDescriptors: [], animation: .default) var invitems: FetchedResults<Item>
    @FetchRequest(sortDescriptors: [], animation: .default) var tags: FetchedResults<Tag>

    @State private var showingDeleteAlert = false
    
    @State private var buyerName   = ""
    @State private var buyerNumber = ""
    @State private var buyerEmail  = ""
    @State private var items       = ""
    @State private var totalItems  = 0
    @State private var totalPrice  = 0
    @State private var tag         = ""
    @State private var method      = "Venmo"
    @State private var dateofpurchase = Date()
    
    @State private var tagName  = ""
    @State private var tagStart = Date()
    @State private var tagEnd   = Date()
    
    let methods = ["Venmo", "Cash"]
    
    var hexColors = readColors()
    
    @Binding var Cart : [cartItem]
    
    func deleteItem(at offsets: IndexSet) {
        for offset in offsets {
            
            Cart.remove(at: offset)
            
            totalPrice = 0
            totalItems = 0
            
            for item in Cart{
                totalPrice = totalPrice + item.itemPrice!
                totalItems = totalItems + item.itemQuantity!
            }
        }
    }
    
    func saveTag(){
        let newTag = Tag(context: viewContext)
        
        newTag.id        = UUID()
        newTag.name      = tagName
        newTag.dateStart = tagStart
        newTag.dateEnd   = tagEnd
        
        try? viewContext.save()
    }
    
    var body: some View{
        NavigationView {
            Form{
                Section{
                    HStack{
                        Text("")
                        Spacer()
                        Text("Personal Information")
                            .font(.title2)
                            .fontWeight(.medium)
                            .fontDesign(.rounded)
                        Spacer()
                    }
                    
                    TextField("Name"                    , text: $buyerName)
                    TextField("Phone Number (Optional)" , text: $buyerNumber)
                    TextField("Email Address (Optional)", text: $buyerEmail)
                    DatePicker("Date of Transaction", selection: $dateofpurchase, displayedComponents: .date)
                }
                
                Section{
                    HStack{
                        Text("")
                        Spacer()
                        Text("Select a Tag")
                            .font(.title2)
                            .fontWeight(.medium)
                            .fontDesign(.rounded)
                        Spacer()
                    }
                    
                    Picker("Tag", selection: $tag)
                    {
                        ForEach(tags){ tag in
                            Text(tag.name ?? "n/a")
                        }
                    }
                    
                    HStack{
                        Text("")
                        Spacer()
                        Text("Create a Tag")
                            .font(.title3)
                            .fontWeight(.medium)
                            .fontDesign(.rounded)
                        Spacer()
                    }
                    
                    TextField("Tag Name", text: $tagName)
                    DatePicker("Select tag START date", selection: $tagStart, displayedComponents: .date)
                    DatePicker("Select tag END date", selection: $tagEnd, displayedComponents: .date)
                    
                    Button{
                        saveTag()
                    } label: {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color(hex: findHex(color: "Pastel Orange", hexColors: hexColors))!)
                            .overlay(
                                Text("Save Tag")
                                    .foregroundColor(.white)
                            )
                    }
                }
                
                Section{
                    HStack{
                        Text("")
                        Spacer()
                        Text("Payment Method")
                            .font(.title2)
                            .fontWeight(.medium)
                            .fontDesign(.rounded)
                        Spacer()
                    }
                    Picker("Payment Method", selection: $method)
                    {
                        ForEach(methods, id: \.self) {
                            Text($0)
                                .fontWeight(.bold)
                                .font(.system(size: 16))
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                    
                    
                }
                
                Section{
                    HStack{
                        Text("Cart")
                            .underline()
                            .font(.system(size: 30))
                            .fontWeight(.bold)
                        
                        Spacer()
                        VStack{
                            Text("Total: $\(totalPrice)")
                            Text("\(totalItems) Items")
                        }
                    }
                    
                    ForEach(Cart, id: \.self) { item in
                        HStack{
                            
                            Text("(\(item.itemQuantity!))")
                                .font(.system(size: 24))
                            
                            VStack{
                                Text(item.itemName!)
                                    .fontWeight(.bold)
                                    .font(.system(size: 20))
                                    .fixedSize()
                                    .frame(width: 200, alignment: .leading)
                            
                                Text("\(item.itemSize!)/\(item.itemColor!)")
                                    .foregroundColor(.gray)
                                    .font(.system(size: 16))
                                    .fixedSize()
                                    .frame(width: 200, alignment: .leading)
                            }
                            
                            Spacer()
                            VStack{
                                Text("$\(item.itemPrice!)")
                                    .font(.system(size:20))
                                if(item.itemQuantity! > 0){
                                    Text("($\(item.itemPrice!/item.itemQuantity!) each)")
                                        .font(.system(size:16))
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                    }
                    .onDelete(perform: deleteItem)
                }
                
                Section{
                    Button{
                        print("Attempting to Complete Purchase")
                        
                        print("Buyer Name: \(buyerName)")
                        print("Purchas Method: \(method)")
                        
                        let newPurchase = Purchase(context: viewContext)
                        
                        for item in Cart{
                            items.append("\(item.itemQuantity!),\(item.itemName!),\(item.itemColor!),\(item.itemSize!);")
                            
                            if let invitem = invitems.first(where: {$0.name == item.itemName!})
                            {
                                invitem.sold = invitem.sold + Int16(item.itemQuantity!)
                                print("Sold \(invitem.sold) \(invitem.name!)")
                            }
                        }
                        
                        print("Cart: \(items)")
                        print("# of Items: \(totalItems)")
                        print("Total Cost: \(totalPrice)")
                        
                        newPurchase.id         = UUID()
                        newPurchase.buyer      = buyerName
                        newPurchase.email      = buyerEmail
                        newPurchase.phone      = buyerNumber
                        newPurchase.items      = items
                        newPurchase.method     = method
                        newPurchase.totalItems = Int16(totalItems)
                        newPurchase.totalPrice = Int16(totalPrice)

                        let date = Date()
                        let dateFormatter = DateFormatter()
                        
                        dateFormatter.dateFormat = "MMM d, YYYY - hh:mm"
                        
                        newPurchase.top          = dateofpurchase
                        newPurchase.purchaseTime = dateFormatter.string(from:date)
                        
                        try? viewContext.save()
                        
                        Cart = [cartItem]()
                        print("Successfully completed \(buyerName)'s purchase")
                        
                        dismiss()
                    } label : {
                        HStack{
                            Spacer()
                            Text("Checkout")
                                .fixedSize()
                                .frame(alignment: .center)
                            Spacer()
                        }
                    }
                }
            }
            .navigationTitle("Checkout")
            .onAppear(perform: {
                for item in Cart{
                    totalPrice = totalPrice + item.itemPrice!
                    totalItems = totalItems + item.itemQuantity!
                }
            })
        }
    }
}

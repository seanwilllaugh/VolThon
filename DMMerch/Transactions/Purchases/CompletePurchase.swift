//
//  CompletePurchase.swift
//  DMMerch
//
//  Created by Sean Laughlin on 8/5/23.
//

import SwiftUI

struct CompletePurchase: View {
    @Environment(\.managedObjectContext) var viewContext
    @FetchRequest(sortDescriptors: [], animation: .default) var tags: FetchedResults<Tag>
    @FetchRequest(sortDescriptors: [], animation: .default) var invitems: FetchedResults<Item>
    
    var hexColors = readColors()
    
    @State private var showingDeleteAlert = false
    
    @State private var buyerFirstName   = ""
    @State private var buyerLastName    = ""
    @State private var buyerNumber      = ""
    @State private var buyerEmail       = ""
    
    @State private var items       = ""
    @State private var totalItems  = 0
    @State private var totalPrice  = 0
    
    @State private var tag         = ""
    
    @State private var method      = "Venmo"
    
    @State private var dateofpurchase = Date()
    
    @State private var selectedTag = ""
    
    @State private var tagName  = ""
    @State private var tagStart = Date()
    @State private var tagEnd   = Date()
    
    let methods = ["Cash", "Venmo", "DonorDrive"]
    
    @Binding var Cart : [cartItem]
    @Binding var blurScale : Double
    @Binding var showingCompleteScreen : Bool
    
    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .stroke(Color(hex: findHex(color: "Pastel Orange", hexColors: hexColors))!, lineWidth: 5)
            .frame(width: 750, height: 700)
            .overlay(
                VStack(alignment: .leading){
                    
                    /* Title and Cancel Button*/
                    HStack{
                        Text("Complete Purchase")
                            .font(Font.custom("LeagueSpartan-Bold", size: 32))
                            .padding(.leading)
                        
                        Spacer()
                        
                        Button{
                            showingCompleteScreen.toggle()
                            blurScale = 0.0
                        } label: {
                            RoundedRectangle(cornerRadius: 5)
                                .fill(.red)
                                .frame(width: 110, height: 40)
                                .overlay(
                                    HStack{
                                        Image(systemName: "trash.fill")
                                            .foregroundColor(.white)
                                            .padding(.leading, 8)
                                        Text("Cancel")
                                            .font(Font.custom("LeagueSpartan", size: 20))
                                            .foregroundColor(.white)
                                        Spacer()
                                    }
                                )
                        }
                        .padding(.trailing)
                    }
                    .padding(.top)
                    
                    HStack(alignment: .top){
                        VStack(alignment: .leading){
                            Text("Name and Contact Info")
                                .font(Font.custom("LeagueSpartan-Bold", size: 24))
                            
                            HStack{
                                VStack(alignment: .leading){
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color(hex: findHex(color: "Pastel Orange", hexColors: hexColors))!)
                                        .opacity(0.1)
                                        .frame(width: 150, height: 30)
                                        .overlay(
                                            ZStack{
                                                RoundedRectangle(cornerRadius: 10)
                                                    .stroke(Color(hex: findHex(color: "Pastel Orange", hexColors: hexColors))!, lineWidth: 2)
                                                
                                                TextField("First Name", text: $buyerFirstName)
                                                    .font(Font.custom("LeagueSpartan", size: 14))
                                                    .padding(.leading, 5)
                                            }
                                        )
                                    
                                    Text("First Name")
                                        .font(Font.custom("LeagueSpartan-Bold", size: 10))
                                        .foregroundColor(.gray)
                                        .padding(.leading, 5)
                                }
                                
                                VStack(alignment: .leading){
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color(hex: findHex(color: "Pastel Orange", hexColors: hexColors))!)
                                        .opacity(0.1)
                                        .frame(width: 150, height: 30)
                                        .overlay(
                                            ZStack{
                                                RoundedRectangle(cornerRadius: 10)
                                                    .stroke(Color(hex: findHex(color: "Pastel Orange", hexColors: hexColors))!, lineWidth: 2)
                                                
                                                TextField("Last Name", text: $buyerLastName)
                                                    .font(Font.custom("LeagueSpartan", size: 14))
                                                    .padding(.leading, 5)
                                            }
                                        )
                                    
                                    Text("Last Name")
                                        .font(Font.custom("LeagueSpartan-Bold", size: 10))
                                        .foregroundColor(.gray)
                                        .padding(.leading, 5)
                                }
                            }
                            
                            HStack{
                                VStack(alignment: .leading){
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color(hex: findHex(color: "Pastel Orange", hexColors: hexColors))!)
                                        .opacity(0.1)
                                        .frame(width: 310, height: 30)
                                        .overlay(
                                            ZStack{
                                                RoundedRectangle(cornerRadius: 10)
                                                    .stroke(Color(hex: findHex(color: "Pastel Orange", hexColors: hexColors))!, lineWidth: 2)
                                                
                                                TextField("Email", text: $buyerEmail)
                                                    .font(Font.custom("LeagueSpartan", size: 14))
                                                    .padding(.leading, 5)
                                            }
                                        )
                                    
                                    Text("Email (Optional)")
                                        .font(Font.custom("LeagueSpartan-Bold", size: 10))
                                        .padding(.leading, 5)
                                        .foregroundColor(.gray)
                                }
                            }
                            
                            HStack{
                                VStack(alignment: .leading){
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color(hex: findHex(color: "Pastel Orange", hexColors: hexColors))!)
                                        .opacity(0.1)
                                        .frame(width: 160, height: 30)
                                        .overlay(
                                            ZStack{
                                                RoundedRectangle(cornerRadius: 10)
                                                    .stroke(Color(hex: findHex(color: "Pastel Orange", hexColors: hexColors))!, lineWidth: 2)
                                                
                                                TextField("Phone Number" , text: $buyerNumber)
                                                    .font(Font.custom("LeagueSpartan-Bold", size: 14))
                                                    .padding(.leading, 5)
                                            }
                                        )
                                    
                                    Text("Phone Number (Optional)")
                                        .font(Font.custom("LeagueSpartan-Bold", size: 10))
                                        .foregroundColor(.gray)
                                        .padding(.leading, 5)
                                }
                                
                                VStack(alignment: .leading){
                                    DatePicker("", selection: $dateofpurchase, displayedComponents: .date)
                                        .frame(width: 142, height: 15)
                                    Text("Date of Purchase")
                                        .font(Font.custom("LeagueSpartan-Bold", size: 10))
                                        .foregroundColor(.gray)
                                        .padding(.leading,30)
                                        .offset(y: 7)
                                }
                            }
                            .padding(.bottom)
                            
                            Text("Select a Tag")
                                .font(Font.custom("LeagueSpartan-Bold", size: 24))
                            
                            HStack{
                                VStack(alignment: .leading){
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color(hex: findHex(color: "Pastel Orange", hexColors: hexColors))!)
                                        .opacity(0.1)
                                        .frame(width: 175, height: 200)
                                        .overlay(
                                            ZStack{
                                                RoundedRectangle(cornerRadius: 10)
                                                    .stroke(Color(hex: findHex(color: "Pastel Orange", hexColors: hexColors))!, lineWidth: 2)
                                                
                                                VStack{
                                                    ForEach(tags){ tag in
                                                        Button{
                                                            selectedTag = tag.name!
                                                        } label: {
                                                            RoundedRectangle(cornerRadius: 10)
                                                                .fill(Color(hex: findHex(color: "Pastel Orange", hexColors: hexColors))!)
                                                                .frame(width: 150, height: 30)
                                                                .overlay(
                                                                    ZStack{
                                                                        Text(tag.name!)
                                                                            .font(Font.custom("LeagueSpartan", size: 14))
                                                                            .foregroundColor(.white)
                                                                    }
                                                                )
                                                        }
                                                    }
                                                    
                                                    Spacer()
                                                }
                                                .padding(.top, 5)
                                            }
                                        )
                                    
                                    Text("Tag List")
                                        .font(Font.custom("LeagueSpartan-Bold", size: 10))
                                        .foregroundColor(.gray)
                                        .padding(.bottom)
                                        .padding(.leading, 5)
                                }
                                
                                VStack(alignment: .center){
                                    Button{
                                        
                                    } label: {
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(Color(hex: findHex(color: "Pastel Orange", hexColors: hexColors))!)
                                            .frame(width: 120, height: 30)
                                            .overlay(
                                                Text("Edit")
                                                    .font(Font.custom("LeagueSpartan-Bold", size: 20))
                                                    .foregroundColor(.white)
                                            )
                                    }
                                    
                                    Button{
                                        selectedTag = ""
                                    } label: {
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(Color(hex: findHex(color: "Pastel Orange", hexColors: hexColors))!)
                                            .frame(width: 120, height: 30)
                                            .overlay(
                                                Text("Clear Tag")
                                                    .font(Font.custom("LeagueSpartan-Bold", size: 20))
                                                    .foregroundColor(.white)
                                            )
                                    }
                                    
                                    Spacer()
                                    
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color(hex: findHex(color: "Pastel Orange", hexColors: hexColors))!, lineWidth: 2)
                                        .frame(width: 120, height: 75)
                                        .overlay(
                                            VStack{
                                                Text("Selected Tag")
                                                    .font(Font.custom("LeagueSpartan-Bold", size: 20))
                                                    .foregroundColor(.black)
                                                    .frame(alignment: .leading)
                                                    .padding(.top, 10)
                                                
                                                Spacer()
                                                
                                                if(selectedTag != ""){
                                                    RoundedRectangle(cornerRadius: 10)
                                                        .fill(Color(hex: findHex(color: "Pastel Orange", hexColors: hexColors))!)
                                                        .frame(width: 110, height: 30)
                                                        .overlay(
                                                            Text(selectedTag)
                                                                .font(Font.custom("LeagueSpartan-Bold", size: 14))
                                                                .foregroundColor(.white)
                                                        )
                                                }
                                                Spacer()
                                            }
                                        )
                                        .padding(.bottom, 35)
                                    
                                }
                                .padding(.leading, 5)
                                .padding(.top)
                            }
                            
                            
                            HStack{
                                Text("Create a Tag")
                                    .font(Font.custom("LeagueSpartan-Bold", size: 24))
                                    .padding(.top, 7)
                                
                                Button{
                                    let newTag = Tag(context: viewContext)
                                    
                                    newTag.id        = UUID()
                                    newTag.name      = tagName
                                    newTag.dateStart = tagStart
                                    newTag.dateEnd   = tagEnd
                                    
                                    try? viewContext.save()
                                    
                                    tagName  = ""
                                    tagStart = Date()
                                    tagEnd   = Date()
                                } label: {
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color(hex: findHex(color: "Pastel Orange", hexColors: hexColors))!)
                                        .frame(width: 90, height: 30)
                                        .overlay(
                                            Text("Save Tag")
                                                .font(Font.custom("LeagueSpartan-Bold", size: 16))
                                                .foregroundColor(.white)
                                        )
                                }
                                .padding(.leading, 80)
                            }
                            
                            HStack{
                                VStack(alignment: .leading){
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color(hex: findHex(color: "Pastel Orange", hexColors: hexColors))!)
                                        .opacity(0.1)
                                        .frame(width: 310, height: 30)
                                        .overlay(
                                            ZStack{
                                                RoundedRectangle(cornerRadius: 10)
                                                    .stroke(Color(hex: findHex(color: "Pastel Orange", hexColors: hexColors))!, lineWidth: 2)
                                                
                                                TextField("Tag Name", text: $tagName)
                                                    .font(Font.custom("LeagueSpartan", size: 14))
                                                    .padding(.leading, 5)
                                            }
                                        )
                                    
                                    Text("Tag Name")
                                        .font(Font.custom("LeagueSpartan-Bold", size: 10))
                                        .foregroundColor(.gray)
                                        .padding(.leading, 5)
                                    
                                }
                            }
                            
                            HStack{
                                VStack(alignment: .leading){
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color(hex: findHex(color: "Pastel Orange", hexColors: hexColors))!)
                                        .opacity(0.1)
                                        .frame(width:150, height: 30)
                                        .overlay(
                                            ZStack{
                                                RoundedRectangle(cornerRadius: 10)
                                                    .stroke(Color(hex: findHex(color: "Pastel Orange", hexColors: hexColors))!, lineWidth: 2)
                                             
                                                DatePicker("", selection: $tagStart, displayedComponents: .date)
                                            }
                                        )
                                    
                                    Text("Start Date")
                                        .font(Font.custom("LeagueSpartan-Bold", size: 10))
                                        .foregroundColor(.gray)
                                        .padding(.leading, 5)
                                    
                                }
                                
                                VStack(alignment: .leading){
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color(hex: findHex(color: "Pastel Orange", hexColors: hexColors))!)
                                        .opacity(0.1)
                                        .frame(width: 150, height: 30)
                                        .overlay(
                                            ZStack{
                                                RoundedRectangle(cornerRadius: 10)
                                                    .stroke(Color(hex: findHex(color: "Pastel Orange", hexColors: hexColors))!, lineWidth: 2)
                                                
                                                DatePicker("", selection: $tagEnd, displayedComponents: .date)
                                            }
                                        )
                                    
                                    Text("End Date")
                                        .font(Font.custom("LeagueSpartan-Bold", size: 10))
                                        .foregroundColor(.gray)
                                        .padding(.leading, 5)
                                }
                            }
                        }
                        .padding(.leading)
                        
                        Spacer()
                        
                        VStack(alignment: .leading){
                            Text("Select Purchase Method")
                                .font(Font.custom("LeagueSpartan-Bold", size: 24))
                            
                      
                            Picker("Payment Method", selection: $method)
                            {
                                ForEach(methods, id: \.self) {
                                    Text($0)
                                        .fontWeight(.bold)
                                        .font(.system(size: 16))
                                }
                            }.pickerStyle(SegmentedPickerStyle())
                            
                            Spacer()
                            
                            HStack{
                                Spacer()
                                
                                    switch method{
                                    case "Venmo":
                                        ZStack{
                                            RoundedRectangle(cornerRadius: 10)
                                                .fill(Color(hex: findHex(color: "Pastel Orange", hexColors: hexColors))!)
                                                .frame(width: 160, height: 160)
                                            Image("DDQR")
                                                .resizable()
                                                .frame(width: 150, height: 150)
                                                .cornerRadius(10)
                                        }
                                        
                                    case "Cash":
                                        Text("Cash")
                                        
                                    case "DonorDrive":
                                        
                                        ZStack{
                                            RoundedRectangle(cornerRadius: 10)
                                                .fill(Color(hex: findHex(color: "Pastel Orange", hexColors: hexColors))!)
                                                .frame(width: 160, height: 160)
                                            Image("DDQR")
                                                .resizable()
                                                .frame(width: 150, height: 150)
                                                .cornerRadius(10)
                                        }
                                        
                                    default:
                                        Text("Venmo")
                                    }
                                
                                Spacer()
                            }
                            .padding(.top)
                            
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color(hex:findHex(color: "Pastel Orange", hexColors: hexColors))!, lineWidth: 2)
                                .frame(width: 380, height: 270)
                                .overlay(
                                    VStack(alignment: .leading){
                                        HStack{
                                            Text("Cart")
                                                .font(Font.custom("LeagueSpartan-Bold", size: 30))
                                                .padding(.top, 10)
                                                .padding(.leading)
                                            Spacer()
                                            
                                            VStack{
                                                Text("Total: $\(totalPrice)")
                                                    .font(Font.custom("LeagueSpartan-Bold", size: 20))
                                                    .padding(.trailing)
                                                Text("\(totalItems) Items")
                                                    .font(Font.custom("LeagueSpartan-Bold", size: 16))
                                                    .padding(.trailing)
                                            }
                                            .padding(.top, 10)
                                        }
                                        
                                        ForEach(Cart.indices, id: \.self) { index in
                                            let item = Cart[index]
                                            
                                            HStack{
                                                Text("\(item.itemQuantity ?? 0)")
                                                    .font(Font.custom("LeagueSpartan-Bold", size: 24))
                                                    .foregroundColor(.black)
                                                    .padding(.leading)
                                                
                                                HStack{
                                                    Circle()
                                                        .frame(width: 25, height: 25)
                                                        .foregroundColor(Color(hex: findHex(color: item.itemColor!, hexColors: hexColors)) ?? .black)
                                                    VStack(alignment: .leading){
                                                        Text(item.itemName ?? "N/A")
                                                            .font(Font.custom("LeagueSpartan-Bold", size: 18))
                                                        
                                                        Text(item.itemType ?? "N/A")
                                                            .font(Font.custom("LeagueSpartan-Bold", size: 14))
                                                            .foregroundColor(.gray)
                                                            .padding(.top, -7)
                                                    }
                                                    Spacer()
                                                }
                                                .padding(.leading)
                                                .frame(width: 200)
                                                
                                                Spacer()
                                                
                                                Text(item.itemSize!)
                                                    .font(Font.custom("LeagueSpartan-Bold", size: 18))
                                                
                                                Spacer()
                                                
                                                Text("$\(item.itemPrice ?? 0)")
                                                    .font(Font.custom("LeagueSpartan-Bold", size: 18))
                                                    .padding(0)
                                                
                                                
                                                Spacer()
                                                
                                                Button{
                                                    Cart.remove(at: index)
                                                } label:{
                                                    Image(systemName: "trash.square.fill")
                                                        .resizable()
                                                        .frame(width: 30, height: 30)
                                                        .foregroundColor(Color(hex: findHex(color: "Pastel Orange", hexColors: hexColors))!)
                                                }
                                                .padding(.trailing)
                                                
                                                
                                            }
                                            .padding(.top)
                                        }
                                        
                                        Spacer()
                                    }
                                        .frame(width: 380, height: 270)
                                )
                                .padding(.top)
                            
                            HStack{
                                Spacer()
                                Button{
                                    print("Attempting to Complete Purchase")
                                    
                                    let newPurchase = Purchase(context: viewContext)
                                    
                                    for item in Cart{
                                        items.append("\(item.itemQuantity!),\(item.itemName!),\(item.itemColor!),\(item.itemSize!);")
                                        
                                        if let invitem = invitems.first(where: {$0.name == item.itemName!})
                                        {
                                            invitem.sold = invitem.sold + Int16(item.itemQuantity!)
                                            print("Sold \(invitem.sold) \(invitem.name!)")
                                        }
                                        
                                        if let itemSize = item.size{
                                            itemSize.inventory = itemSize.inventory - Int16(item.itemQuantity!)
                                        }
                                    }
                                    
                                    print("Cart: \(items)")
                                    print("# of Items: \(totalItems)")
                                    print("Total Cost: \(totalPrice)")
                                    
                                    newPurchase.id         = UUID()
                                    newPurchase.buyer      = buyerFirstName + " " + buyerLastName
                                    newPurchase.email      = buyerEmail
                                    newPurchase.phone      = buyerNumber
                                    newPurchase.items      = items
                                    newPurchase.method     = method
                                    newPurchase.totalItems = Int16(totalItems)
                                    newPurchase.totalPrice = Int16(totalPrice)
                                    newPurchase.tag        = selectedTag

                                    let date = Date()
                                    let dateFormatter = DateFormatter()
                                    
                                    dateFormatter.dateFormat = "MMM d, YYYY - hh:mm"
                                    
                                    newPurchase.top          = dateofpurchase
                                    newPurchase.purchaseTime = dateFormatter.string(from:date)
                                    
                                    try? viewContext.save()
                                    
                                    Cart = [cartItem]()
                                    
                                    showingCompleteScreen = false
                                    blurScale = 0.0
                                } label: {
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color(hex: findHex(color: "Pastel Orange", hexColors: hexColors))!)
                                        .frame(width: 200, height: 60)
                                        .overlay(
                                            Text("Complete Purchase")
                                                .font(Font.custom("LeagueSpartan-Bold", size: 21))
                                                .foregroundColor(.white)
                                        )
                                }
                                .padding(.top, 5)
                                .padding(.bottom)
                                Spacer()
                            }
                        }
                        .padding(.leading)
                        .padding(.trailing,5)
                        
                        Spacer()
                    }
                    
                    Spacer()
                }
                    .onAppear(perform: {
                        for item in Cart{
                            totalPrice = totalPrice + item.itemPrice!
                            totalItems = totalItems + item.itemQuantity!
                        }
                    })
            )
    }
}


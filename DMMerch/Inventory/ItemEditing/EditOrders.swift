//
//  EditOrders.swift
//  DMMerch
//
//  Created by Sean Laughlin on 8/1/23.
//

import SwiftUI

struct EditOrders: View {
    @Environment(\.managedObjectContext) var viewContext
    var item: Item
    
    let hexColors = readColors()
    
    @Binding var editingOrders : Bool
    
    @State var orderDate   = Date()
    @State var orderAmount = "0"
    @State var orderCost   = "0"
    
    func saveOrder(){
        item.lastOrderDate = orderDate
        item.lastOrderAmt  = Int16(orderAmount)!
        item.lastOrderCost = Int16(orderCost)!
        
        try? viewContext.save()
    }
    
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 20)
                .fill(.white)
                .frame(width: 350, height: 250)
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(hex: findHex(color: "Pastel Orange", hexColors: hexColors))!)
                .opacity(0.1)
                .frame(width: 350, height: 250)
                .overlay(
                    ZStack{
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color(hex: findHex(color: "Pastel Orange", hexColors: hexColors))!, lineWidth: 5)
                        
                        VStack{
                            HStack{
                                Text("New Order")
                                    .font(Font.custom("LeagueSpartan-Bold", size: 36))
                                
                                Spacer()
                            }
                            .padding(.top)
                            
                            Spacer()
                            
                            DatePicker("Order Placed On", selection: $orderDate, displayedComponents: .date)
                                .font(Font.custom("LeagueSpartan", size: 20))
                            
                            HStack{
                                Text("Amount Ordered")
                                    .font(Font.custom("LeagueSpartan", size: 20))
                                
                                Spacer()
                                
                                TextField("", text: $orderAmount)
                                    .textFieldStyle(.roundedBorder)
                                    .multilineTextAlignment(.trailing)
                                    .font(Font.custom("LeagueSpartan", size: 20))
                                    .frame(width: 100)
                            }
                            
                            HStack{
                                Text("Cost")
                                    .font(Font.custom("LeagueSpartan", size: 20))
                                
                                Spacer()
                                
                                TextField("", text: $orderCost)
                                    .textFieldStyle(.roundedBorder)
                                    .multilineTextAlignment(.trailing)
                                    .font(Font.custom("LeagueSpartan", size: 20))
                                    .frame(width: 100)
                            }
                            
                            Spacer()
                            
                            Button{
                                saveOrder()
                                editingOrders = false
                            } label: {
                                ZStack{
                                    RoundedRectangle(cornerRadius: 5)
                                        .fill(Color(hex: findHex(color: "Pastel Orange", hexColors: hexColors))!)
                                        .frame(width: 150, height: 50)
                                    
                                    Text("Save Order")
                                        .font(Font.custom("LeagueSpartan-Bold", size: 24))
                                        .foregroundColor(.black)
                                }
                            }
                            .padding(.bottom)
                        }
                        .padding(.leading)
                        .padding(.trailing)
                    }
                )
        }
        .onAppear{
            if(item.lastOrderDate != nil){
                orderDate = item.lastOrderDate!
            }
            orderAmount = String("\(item.lastOrderAmt)")
            orderCost   = String("\(item.lastOrderCost)")
        }
    }
}


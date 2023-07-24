//
//  PurchaseRow.swift
//  DMMerch
//
//  Created by Sean Laughlin on 2/18/23.
//

import SwiftUI
import CoreData
import Foundation

struct PurchaseRow: View {
    @Environment(\.managedObjectContext) var viewContext
    
    let item: Item
    
    @Binding var Cart  : [cartItem]
    @State var newItem = cartItem()
    
    @State var Quantity    = 0
    @State var chosenColor = ""
    @State var chosenSize  = ""
    
    @State var purchaseString   = String()
    @State var Sizes            = [String]()
    @State var Colors           = [String]()
    
    func seperateColors()->[String]{
        let colorsConverted = item.colors!
        
        let new = colorsConverted.description.components(separatedBy: ",")
        
        return(new)
    }
    
    func seperateSizes()->[String]{
        let sizesConverted = item.sizes!
        
        let new = sizesConverted.description.components(separatedBy: ",")
        
        return(new)
    }
    
    var body: some View {
        HStack{
            Text("$\(item.price)")
                .frame(width: 60, height: 60)
                .foregroundColor(.white)
                .background(
                    Circle()
                        .frame(width:45, height: 45)
                        .foregroundColor(.orange)
                        .shadow(radius: 5)
                )
                .offset(x:-75)
            
            VStack{
                Text(item.name!)
                    .fontWeight(.bold)
                    .frame(width: 170, alignment: .leading)
                    .foregroundColor(.black)
                    .offset(x:-75)
                Text(item.type!)
                    .foregroundColor(.black)
                    .frame(width: 170, alignment: .leading)
                    .offset(x:-75)
            }
            
            HStack{
                Picker("", selection: $chosenColor){
                    ForEach(Colors, id: \.self) {
                        Text("\($0)")
                    }
                }
                .frame(width: 100, height: 30, alignment: .leading)
                .offset(x:-35)
                
                Picker("", selection: $chosenSize){
                    ForEach(Sizes, id: \.self) {
                        Text("\($0)")
                    }
                }
                .frame(width: 100, height: 30, alignment: .leading)
                .foregroundColor(.black)
                .offset(x:-5)
            }
            
            MyStepper(value: $Quantity, in: 1...100, label: { Text("") }, style: CapsuleStepperStyle())
                .controlSize(.regular)
                .frame(width:100)
                .offset(x:-10)
            
            Button{
                newItem = AddtoCart(item: item, Quantity: Quantity, Color: chosenColor, Size: chosenSize)
                Cart.append(newItem)
                Quantity = 0
                print("Added \(Cart[0].itemQuantity!) \(Cart[0].itemName!)")
            } label: {
                Image(systemName: "cart.badge.plus")
                    .font(.system(size: 24))
                    .fixedSize()
                    .fontWeight(.bold)
                    .foregroundColor(Color.white)
                    .frame(width: 80, height: 40)
                    .background(Rectangle())
                    .foregroundColor(.orange)
                    .cornerRadius(5)
            }
            .offset(x:50)
        }
        .navigationTitle("New Transaction")
        .onAppear(perform: {
            Colors = seperateColors()
            Sizes  = seperateSizes()
            chosenColor = Colors[0]
            chosenSize  = Sizes[0]
        })
    }
}

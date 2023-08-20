//
//  PurchaseCard.swift
//  DMMerch
//
//  Created by Sean Laughlin on 7/12/23.
//

import SwiftUI

struct PurchaseCard: View {
    var hexColors = readColors()
    @Environment(\.managedObjectContext) var viewContext
    
    let item: Item
    
    @State var image  = UIImage()
    
    @Binding var Cart  : [cartItem]
    @State var newItem = cartItem()
    
    @State var selectedColor = ItemColor()
    @State var colorSelected = false
    
    @State var selectedSize  = ItemSize()
    @State var sizeSelected  = false
    
    @State var selectedAmt   = 0
    
    @State var errorCheck    = false
    
    func loadImage()->UIImage{
        guard UIImage(data: item.image!) != nil else{
            return UIImage(imageLiteralResourceName: "FTKShirt")
        }
        
        return UIImage(data: item.image!)!
    }
    
    var body: some View {
        
        RoundedRectangle(cornerRadius: 20)
            .fill(Color(hex: findHex(color: "Pastel Orange", hexColors: hexColors)) ?? .black)
            .opacity(0.1)
            .overlay(
                VStack(){
                    HStack(alignment: .top){
                        Image(uiImage: image)
                            .resizable()
                            .frame(width: 90, height: 100)
                            .cornerRadius(20)
                            .padding(.leading)
                        
                        VStack(alignment: .leading){
                            Text(item.name ?? "N/A")
                                .font(Font.custom("LeagueSpartan-Bold", size: 15))
                                .foregroundColor(.black)
                            
                            Text(item.type ?? "N/A")
                                .font(Font.custom("LeagueSpartan-Bold", size: 13))
                                .foregroundColor(Color(hex: findHex(color: "Pastel Gray", hexColors: hexColors)) ?? .black)
                            
                            HStack{
                                RoundedRectangle(cornerRadius: 10)
                                    .frame(width: 120, height: 42)
                                    .foregroundColor(.clear)
                                    .overlay(
                                        ZStack{
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(Color(hex: findHex(color: "Pastel Orange", hexColors: hexColors)) ?? .black, lineWidth: 1)
                                            VStack(alignment: .center){
                                                Spacer()
                                                
                                                Text("Select Amount")
                                                    .font(Font.custom("LeagueSpartan", size: 11))
                                                    .foregroundColor(.black)
                                                    .offset(y: -4)
                                                
                                                
                                                HStack{
                                                    Button{
                                                        if(selectedAmt > 0){
                                                            selectedAmt = selectedAmt - 1
                                                        }
                                                    } label: {
                                                        ZStack{
                                                            Circle()
                                                                .strokeBorder(Color(hex: findHex(color: "Pastel Orange", hexColors: hexColors)) ?? .black, lineWidth: 1)
                                                                .foregroundColor(.clear)
                                                                .frame(width: 20, height: 20)
                                                            Image(systemName: "minus")
                                                                .resizable()
                                                                .frame(width: 13, height: 3)
                                                                .foregroundColor(.black)
                                                        }
                                                    }
                                                    
                                                    Text("\(selectedAmt)")
                                                        .font(Font.custom("LeagueSpartan", size: 16))
                                                        .foregroundColor(.black)
                                                    
                                                    Button{
                                                        selectedAmt = selectedAmt + 1
                                                    } label: {
                                                        ZStack{
                                                            Circle()
                                                                .strokeBorder(Color(hex: findHex(color: "Pastel Orange", hexColors: hexColors)) ?? .black, lineWidth: 1)
                                                                .foregroundColor(.clear)
                                                                .frame(width: 20, height: 20)
                                                            Image(systemName: "plus")
                                                                .resizable()
                                                                .frame(width: 13, height: 13)
                                                                .foregroundColor(.black)
                                                        }
                                                    }
                                                }
                                            
                                                Spacer()
                                            }
                                        }
                                    )
                            }
                            .padding(.top, 5)
                            .padding(.leading)
                        }
                        Spacer()
                    }
                    //Spacer()
                    HStack{
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: 180, height: 85)
                            .foregroundColor(.clear)
                            .overlay(
                                ZStack(){
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color(hex: findHex(color: "Pastel Orange", hexColors: hexColors)) ?? .black, lineWidth: 1)
                                    HStack{
                                        VStack(alignment: .leading){
                                            Text("Select Color")
                                                .font(Font.custom("LeagueSpartan", size: 12))
                                                .foregroundColor(.black)
                                            HStack{
                                                ForEach(item.colorArray){ color in
                                                    Button{
                                                        selectedColor = color
                                                        colorSelected = true
                                                    } label: {
                                                        if(selectedColor == color){
                                                            ZStack{
                                                                Circle()
                                                                    .frame(width: 20, height: 20)
                                                                    .foregroundColor(Color(hex: findHex(color: color.colorName!, hexColors: hexColors)) ?? .black)
                                                                Circle()
                                                                    .strokeBorder(Color(hex: findHex(color: "Pastel Orange", hexColors: hexColors)) ?? .black, lineWidth: 2)
                                                                    .frame(width: 20, height: 20)
                                                            }
                                                            .padding(.top, -5)
                                                        }else{
                                                            Circle()
                                                                .frame(width: 20, height: 20)
                                                                .foregroundColor(Color(hex: findHex(color: color.colorName!, hexColors: hexColors)) ?? .black)
                                                                .padding(.top, -5)
                                                        }
                                                    }
                                                }
                                            }
                                            Text("Select Size")
                                                .font(Font.custom("LeagueSpartan", size: 12))
                                                .foregroundColor(.black)
                                                .padding(.top, -3)
                                            HStack{
                                                if let firstColor = item.colorArray.first {
                                                    ForEach(firstColor.sizeArray){ size in
                                                        Button{
                                                            selectedSize = size
                                                            sizeSelected = true
                                                        } label: {
                                                            if(selectedSize == size){
                                                                ZStack{
                                                                    RoundedRectangle(cornerRadius: 5)
                                                                        .foregroundColor(Color(hex: findHex(color: "Size Gray", hexColors: hexColors))!)
                                                                        .frame(width: 20, height: 20)
                                                                        .padding(.top, -6)
                                                                        .overlay(
                                                                            Text(size.sizeName!)
                                                                                .font(Font.custom("LeagueSpartan", size: 10))
                                                                                .padding(.bottom, 3)
                                                                                .foregroundColor(.black)
                                                                        )
                                                                    RoundedRectangle(cornerRadius: 5)
                                                                        .stroke(Color(hex: findHex(color: "Pastel Orange", hexColors: hexColors))!, lineWidth: 2)
                                                                        .frame(width: 20, height: 20)
                                                                        .padding(.top, -6)
                                                                }
                                                            }else{
                                                                ZStack{
                                                                    RoundedRectangle(cornerRadius: 5)
                                                                        .foregroundColor(Color(hex: findHex(color: "Size Gray", hexColors: hexColors))!)
                                                                        .frame(width: 20, height: 20)
                                                                        .padding(.top, -6)
                                                                        .overlay(
                                                                            Text(size.sizeName!)
                                                                                .font(Font.custom("LeagueSpartan", size: 10))
                                                                                .padding(.bottom, 3)
                                                                                .foregroundColor(.black)
                                                                        )
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                        Spacer()
                                    }
                                    .padding(.leading, 10)
                                    
                                    Spacer()
                                }
                            )
                            .padding(.leading)
                        
                        Spacer()
                        
                        VStack(alignment: .center){
                            Text("$\(item.price)")
                                .font(Font.custom("LeagueSpartan-Bold", size: 24))
                                .foregroundColor(.black)
                                .padding(.bottom, -1)
                            
                            if(countInventoryTotal(item: item) <= 0){
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundColor(Color(hex: findHex(color: "Pastel Gray", hexColors: hexColors)) ?? .black)
                                    .overlay(
                                        ZStack{
                                            Text("Add to Cart")
                                                .font(.system(size: 10))
                                                .foregroundColor(.white)
                                                .fontWeight(.bold)
                                        }
                                    )
                                    .frame(width: 85, height: 30)
                            }else{
                                Button{
                                    if(sizeSelected && colorSelected){
                                        if(selectedAmt > 0){
                                            newItem = AddtoCart(item: item, Quantity: selectedAmt, Color: selectedColor, Size: selectedSize)
                                            Cart.append(newItem)
                                            selectedAmt = 0
                                            selectedColor = ItemColor()
                                            selectedSize  = ItemSize()
                                            print("Added \(Cart[0].itemQuantity!) \(Cart[0].itemName!)")
                                            
                                            errorCheck = false
                                        }else{
                                            errorCheck = true
                                        }
                                    }else{
                                        errorCheck = true
                                    }
                                } label: {
                                    ZStack{
                                        if(errorCheck){
                                            RoundedRectangle(cornerRadius: 10)
                                                .foregroundColor(Color(hex: findHex(color: "Red", hexColors: hexColors)) ?? .black)
                                                .overlay(
                                                    ZStack{
                                                        Text("Add to Cart")
                                                            .font(.system(size: 10))
                                                            .foregroundColor(.white)
                                                            .fontWeight(.bold)
                                                    }
                                                )
                                        }else{
                                            RoundedRectangle(cornerRadius: 10)
                                                .foregroundColor(Color(hex: findHex(color: "Pastel Orange", hexColors: hexColors)) ?? .black)
                                                .overlay(
                                                    ZStack{
                                                        Text("Add to Cart")
                                                            .font(.system(size: 10))
                                                            .foregroundColor(.white)
                                                            .fontWeight(.bold)
                                                    }
                                                )
                                        }
                                    }
                                }
                                .frame(width: 85, height: 30)
                            }
                        }
                        .frame(height: 85)
                        .padding(.trailing)
                    }
                }
            )
            .frame(width: 300, height: 210)
            .onAppear(perform: {
                image = loadImage()
            })
            
    }
}

func AddtoCart(item: Item, Quantity: Int, Color: ItemColor, Size: ItemSize)->cartItem
{
    print("AddtoCart called")
    
    var newItem        = cartItem()
    var purchaseString = String()
    
    purchaseString.append("\(item.name!);")
    purchaseString.append("\(Quantity);")
    purchaseString.append("\(Int(item.price) * Quantity);")
    purchaseString.append("\(Color.colorName!);")
    purchaseString.append("\(Size.sizeName!);")
    
    newItem.itemName     = item.name!
    newItem.itemQuantity = Quantity
    newItem.itemPrice    = Int(item.price) * Quantity
    newItem.itemColor    = Color.colorName!
    newItem.itemSize     = Size.sizeName!
    newItem.itemType     = item.type!
    
    newItem.size         = Size
    
    return newItem
}

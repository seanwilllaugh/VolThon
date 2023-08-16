//
//  InventoryCard.swift
//  DMMerch
//
//  Created by Sean Laughlin on 7/6/23.
//

import SwiftUI

struct InventoryCard: View {
    var hexColors = readColors()
    @Environment(\.managedObjectContext) var viewContext
    @FetchRequest(sortDescriptors: [], animation: .default) var types: FetchedResults<ItemColor>
    
    let item: Item
    
    @State var image  = UIImage()
    
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
                                //.font(.system(size:14))
                            Text(item.type ?? "N/A")
                                .font(Font.custom("LeagueSpartan-Bold", size: 13))
                                .foregroundColor(Color(hex: findHex(color: "Pastel Gray", hexColors: hexColors)) ?? .black)
                            
                            HStack{
                                RoundedRectangle(cornerRadius: 10)
                                    .frame(width: 80, height: 50)
                                    .foregroundColor(.clear)
                                    .overlay(
                                        ZStack{
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(Color(hex: findHex(color: "Pastel Orange", hexColors: hexColors)) ?? .black, lineWidth: 1)
                                            VStack{
                                                Text("Total Sold")
                                                    .font(Font.custom("LeagueSpartan", size: 11))
                                                    .foregroundColor(.black)
                                                    .offset(y: -4)
                                                Text("\(item.sold)")
                                                    .font(Font.custom("LeagueSpartan", size: 15))
                                                    .foregroundColor(.black)
                                            }
                                        }
                                    )
                                RoundedRectangle(cornerRadius: 10)
                                    .frame(width: 80, height: 50)
                                    .foregroundColor(.clear)
                                    .overlay(
                                        ZStack{
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(Color(hex: findHex(color: "Pastel Orange", hexColors: hexColors)) ?? .black, lineWidth: 1)
                                            
                                            VStack{
                                                Text("Inventory Left")
                                                    .foregroundColor(.black)
                                                    .font(Font.custom("LeagueSpartan", size: 11))
                                                    .offset(y: -4)
                                                Text("\(countInventoryTotal(item: item))")
                                                    .foregroundColor(.black)
                                                    .font(Font.custom("LeagueSpartan", size: 15))
                                            }
                                            .frame(height: 34)
                                        }
                                    )
                            }
                            .padding(.top, 5)
                        }
                        Spacer()
                    }
                    
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
                                            Text("Available Colors")
                                                .font(Font.custom("LeagueSpartan", size: 12))
                                                .foregroundColor(.black)
                                            HStack{
                                                ForEach(item.colorArray){ color in
                                                    Circle()
                                                        .frame(width: 20, height: 20)
                                                        .foregroundColor(Color(hex: findHex(color: color.colorName!, hexColors: hexColors)) ?? .black)
                                                        .padding(.top, -5)
                                                }
                                            }
                                            Text("Available Sizes")
                                                .font(Font.custom("LeagueSpartan", size: 12))
                                                .foregroundColor(.black)
                                                .padding(.top, -3)
                                            HStack{
                                                if let firstColor = item.colorArray.first {
                                                    ForEach(firstColor.sizeArray){ size in
                                                        ZStack{
                                                            RoundedRectangle(cornerRadius: 5)
                                                                .foregroundColor(Color(hex: findHex(color: "Size Gray", hexColors: hexColors))!)
                                                                .frame(width: 20, height: 20)
                                                                .padding(.top, -6)
                                                            Text(size.sizeName!)
                                                                .font(Font.custom("LeagueSpartan", size: 10))
                                                                .padding(.bottom, 5)
                                                                .foregroundColor(.black)
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
                            Button{
                                
                            } label: {
                                ZStack{
                                    RoundedRectangle(cornerRadius: 10)
                                        .foregroundColor(Color(hex: findHex(color: "Pastel Orange", hexColors: hexColors)) ?? .black)
                                        .overlay(
                                            ZStack{
                                                NavigationLink{
                                                    ItemDetailView(item: item)
                                                } label: {
                                                    Text("View More")
                                                        .font(.system(size: 11))
                                                        .foregroundColor(.white)
                                                        .fontWeight(.bold)
                                                }
                                            }
                                        )
                                }
                            }
                            .frame(width: 85, height: 30)
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

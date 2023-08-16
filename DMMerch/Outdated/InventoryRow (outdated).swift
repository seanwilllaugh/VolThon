//
//  Inventory Row.swift
//  DMMerch
//
//  Created by Sean Laughlin on 3/2/23.
//
/*
import SwiftUI

struct InventoryRow: View {
    @Environment(\.managedObjectContext) var viewContext
    
    let item: Item
    
    @State var Sizes            = [String]()
    @State var Colors           = [String]()
    
    let hexColors = readColors()
    
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
                .foregroundColor(.white)
                .background(
                    Circle()
                        .frame(width:45, height: 45)
                        .foregroundColor(Color(hex: findHex(color: "Pastel Orange", hexColors: hexColors)))
                        .shadow(radius: 5)
                )
                .padding(.leading)
                .padding(.trailing)
                .fixedSize()
                .frame(width: 60, height: 60)
            
            VStack{
                Text(item.name!)
                    .fontWeight(.bold)
                    .frame(width: 170, alignment: .leading)
                    .foregroundColor(.black)
                    .shadow(radius: 1)
                Text(item.type!)
                    .foregroundColor(.black)
                    .frame(width: 170, alignment: .leading)
            }
            .fixedSize()
            .frame(height:30)
            
            VStack{
                Text("Sizes")
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .shadow(radius: 1)
                    .frame(width: 350, alignment: .leading)
                
                
                HStack{
                    ForEach(Sizes, id: \.self){ size in
                        Text(size)
                            .font(.system(size: 12))
                    }
                }
                .foregroundColor(.black)
                .frame(width: 350, alignment: .leading)
            }
            
            Spacer()
            
            ForEach(Colors, id: \.self){ color in
                Circle()
                    .shadow(radius: 5)
                    .foregroundColor(Color(hex: findHex(color: color, hexColors: hexColors)) ?? .black)
            }
            .frame(width: 30, height: 30)
        
            
            
            Image(systemName: "arrowshape.turn.up.forward.circle")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(Color.black)
                .frame(width:45, height:45)
                .padding(.trailing)
                .padding(.leading)
        }
        .onAppear(perform: {
            Colors = seperateColors()
            Sizes  = seperateSizes()
        })
    }
}
*/

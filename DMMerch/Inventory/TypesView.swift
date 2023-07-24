//
//  AddTypeView.swift
//  DMMerch
//
//  Created by Sean Laughlin on 7/20/23.
//

import SwiftUI

struct TypesView: View {
    @Environment(\.managedObjectContext) var viewContext
    @Environment(\.dismiss) var dismiss
    @FetchRequest(sortDescriptors: [], animation: .default) var items: FetchedResults<Item>
    @FetchRequest(sortDescriptors: [], animation: .default) var types: FetchedResults<ItemType>
    
    let hexColors = readColors()
    
    @State private var newName = ""
    
    func saveType()
    {
        let newType = ItemType(context: viewContext)
        
        newType.id = UUID()
        newType.name = newName
        
        try? viewContext.save()
        dismiss()
    }
    
    func deleteItem(at offsets: IndexSet) {
        for offset in offsets {
            let type = types[offset]
            
            viewContext.delete(type)
        }
        
        try? viewContext.save()
    }
    
    var body: some View {
        VStack{
            Text("Add Type")
                .font(Font.custom("LeagueSpartan-Bold", size: 24))
                .foregroundColor(.black)
                .padding(.top)
            
            List{
                ForEach(types){ type in
                    Text(type.name!)
                        .font(Font.custom("LeagueSpartan", size: 18))
                }
                .onDelete(perform: deleteItem)
            }
            
            
            Text("Add Type")
                .font(Font.custom("LeagueSpartan-Bold", size: 24))
                .foregroundColor(.black)
            
            Form{
                Section(header: Text("Type Name")){
                    TextField("Name", text: $newName)
                }
            }
            
            Button{
                saveType()
            }label:{
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(Color(hex: findHex(color: "Pastel Orange", hexColors: hexColors)))
                    .frame(width: 200, height: 75)
                    .overlay(
                        Text("Save Type")
                            .font(Font.custom("LeagueSpartan-Bold", size: 20))
                            .foregroundColor(.white)
                    )
            }
            .padding(.bottom)
        }
    }
}


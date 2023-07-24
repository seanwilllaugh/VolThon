//
//  AddItemView.swift
//  DMMerch
//
//  Created by Sean Laughlin on 2/17/23.
//

import SwiftUI
import PhotosUI
import UIKit

struct AddItemView: View{
    @Environment(\.managedObjectContext) var viewContext
    @Environment(\.dismiss) var dismiss
    @FetchRequest(sortDescriptors: [SortDescriptor(\.name)], animation: .default) var types: FetchedResults<ItemType>
    
    let columns = [
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible())
        ]

    let hexColors = readColors()
    
    @State private var name   = ""
    @State private var type   = ""
    
    @State private var onecolor  = ""
    @State private var colorlist = [""]
    @State private var color     = ""
    
    @State private var size     = ""
    @State private var sizelist = [""]
    @State private var xsmall   = false
    @State private var small    = false
    @State private var medium   = false
    @State private var large    = false
    @State private var xlarge   = false
    @State private var xxlarge  = false
    @State private var xxxlarge = false 
    @State private var onesize  = false
    
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    
    @State private var stock  = ""
    
    @State private var price  = 0
    
    func deleteColor(at offsets: IndexSet){
        for offset in offsets {
            colorlist[offset] = ""
        }
    }
    
    func saveItem()
    {
        let newItem = Item(context: viewContext)
        
        if(xsmall){
            sizelist.append("XS")
        }
        if(small){
            sizelist.append("SM")
        }
        if(medium){
            sizelist.append("MD")
        }
        if(large){
            sizelist.append("LG")
        }
        if(xlarge){
            sizelist.append("XL")
        }
        if(xxlarge){
            sizelist.append("XXL")
        }
        if(onesize){
            sizelist.append("OS")
        }
        
        var i = 0
        
        for newsize in sizelist{
            if(newsize != "")
            {
                size += newsize
                if(i != sizelist.endIndex-1){
                    size += ","
                }
            }
            i += 1
        }
        
        i = 0
        
        for newcolor in colorlist{
            if(newcolor != "")
            {
                color += newcolor
                if(i != colorlist.endIndex-1){
                    color += ","
                }
            }
            i += 1
        }
        
        newItem.id    = UUID()
        newItem.name  = name
        newItem.type  = type
        newItem.colors = color
        newItem.sizes  = size
        newItem.price = Int16(price)
        newItem.image = inputImage!.pngData()
        
        for typeName in types{
            if(type == typeName.name!){
                typeName.typeCount = typeName.typeCount + 1
                break
            }
        }
        
        try? viewContext.save()
        dismiss()
    }
    
    var body: some View{
        NavigationView {
            Form{
                Section(header: Text("Item Name")){
                    TextField("Name of Item" , text: $name)
                }
                
                Section(header: Text("Item Type")){
                    Picker("Choose Item's Type", selection: $type){
                        ForEach(types.indices, id: \.self) { index in
                            Text("\(types[index].name!)")
                                .tag(types[index].name!)
                        }
                    }
                }
                
                Section(header: Text("Colors")){
                    TextField("Enter a Color", text: $onecolor)
                        .onSubmit {
                            colorlist.append(onecolor)
                            
                            onecolor = ""
                        }
                }
                
                ForEach(colorlist, id: \.self){ addedcolor in
                    if(addedcolor != "")
                    {
                        HStack{
                            Circle()
                                .frame(width:25, height:25)
                                .shadow(radius: 5)
                                .foregroundColor(Color(hex: findHex(color: addedcolor, hexColors: hexColors)) ?? .black)
                                .padding(.trailing)
                            
                            Text(addedcolor)
                            
                            Spacer()
                            
                            Text("Swipe to delete")
                                .font(.system(size: 10))
                                .foregroundColor(.gray)
                                .fontWeight(.light)
                        }
                    }
                }
                .onDelete(perform: deleteColor)
                
                Section(header: Text("Sizes")){
                    LazyVGrid(columns: columns, spacing: 20){
                        Toggle("X-Small", isOn: $xsmall)
                            .toggleStyle(.button)
                        Toggle("Small", isOn: $small)
                            .toggleStyle(.button)
                        Toggle("Medium", isOn: $medium)
                            .toggleStyle(.button)
                        Toggle("Large", isOn: $large)
                            .toggleStyle(.button)
                        Toggle("X-Large", isOn: $xlarge)
                            .toggleStyle(.button)
                        Toggle("XX-Large", isOn: $xxlarge)
                            .toggleStyle(.button)
                        Toggle("XXX-Large", isOn: $xxxlarge)
                            .toggleStyle(.button)
                        Toggle("One Size", isOn: $onesize)
                            .toggleStyle(.button)
                    }
                }
                
                if let image = inputImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                }
                
                Button{
                    self.showingImagePicker = true
                } label:{
                    Text("Select an Image")
                        .offset(x: 250)
                }
                .sheet(isPresented: $showingImagePicker) {
                    ImagePicker(image: self.$inputImage)
                }
            
                
                Section(header: Text("Price")){
                    TextField("Price of Item", value: $price, format: .number)
                }
                
                Section{
                    Button("Save"){
                        saveItem()
                    }
                }
            }
            .navigationTitle("Add Item")
            .toolbar(){
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button{
                        saveItem()
                    } label: {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
        }
    }
}

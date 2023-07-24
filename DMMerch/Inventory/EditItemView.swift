//
//  EditItemView.swift
//  DMMerch
//
//  Created by Sean Laughlin on 2/17/23.
//

import SwiftUI

struct EditItemView: View{
    @Environment(\.managedObjectContext) var viewContext
    @Environment(\.dismiss) var dismiss
    
    let columns = [
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible())
        ]

    let hexColors = readColors()
    
    @State var item : Item
    
    @State var Colors = [String]()
    @State var Sizes  = [String]()
    
    @State private var name   = ""
    @State private var type   = ""
    
    @State private var onecolor  = ""
    @State private var colorlist = [""]
    @State private var color     = ""
    
    @State private var typeList = ["T-Shirts", "Hoodies", "Sweatshirts", "Pants", "Totes/Bags", "Buttons", "Flowers", "Bags", "Stickers", "Bottles", "Other"]
    
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
    
    func deleteColor(at offsets: IndexSet){
        for offset in offsets {
            colorlist[offset] = ""
        }
    }
    
    func saveItem()
    {
        if(xsmall){
            sizelist.append("X-Small")
        }
        if(small){
            sizelist.append("Small")
        }
        if(medium){
            sizelist.append("Medium")
        }
        if(large){
            sizelist.append("Large")
        }
        if(xlarge){
            sizelist.append("X-Large")
        }
        if(xxlarge){
            sizelist.append("XX-Large")
        }
        if(xxxlarge){
            sizelist.append("XXX-Large")
        }
        if(onesize){
            sizelist.append("One Size")
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
        
        item.name  = name
        item.type  = type
        item.colors = color
        item.sizes  = size
        item.price = Int16(price)
        item.image = inputImage!.pngData()
        
        try? viewContext.save()
        dismiss()
    }
    
    var body: some View{
        NavigationView {
            Form{
                Section(header: Text("Item Info")){
                    TextField("Name of Item" , text: $name)
                }
                
                Section(header: Text("Item Type")){
                    Picker("", selection: $type){
                        ForEach(typeList, id: \.self) {
                            Text("\($0)")
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
                
                Section{
                    if let image = inputImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                    }
                    
                    Button{
                        self.showingImagePicker = true
                    } label: {
                        Text("Select an Image")
                            .offset(x: 250)
                    }
                    .sheet(isPresented: $showingImagePicker) {
                        ImagePicker(image: self.$inputImage)
                    }
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
            .onAppear(perform: {
                name = item.name!
                type = item.type!
                
                price = Int(item.price)
                
                Colors = seperateColors()
                Sizes  = seperateSizes()
                
                colorlist = Colors
                sizelist  = Sizes
                
                for size in sizelist{
                    if(size == "X-Small"){
                        xsmall = true
                    }
                    if(size == "Small"){
                        small = true
                    }
                    if(size == "Medium"){
                        medium = true
                    }
                    if(size == "Large"){
                        large = true
                    }
                    if(size == "X-Large"){
                        xlarge = true
                    }
                    if(size == "XX-Large"){
                        xxlarge = true
                    }
                    if(size == "XXX-Large"){
                        xxxlarge = true
                    }
                    if(size == "One Size"){
                        onesize = true
                    }
                }
                
                sizelist = [""]
                
            })
            .navigationTitle("Edit Item: \(item.name!)")
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

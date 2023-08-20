//
//  AddItem.swift
//  DMMerch
//
//  Created by Sean Laughlin on 8/17/23.
//

import SwiftUI

struct AddItem: View {
    @Environment(\.managedObjectContext) var viewContext
    @Environment(\.dismiss) var dismiss
    @FetchRequest(sortDescriptors: [SortDescriptor(\.name)], animation: .default) var types: FetchedResults<ItemType>
    
    let columns = [
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
    
    @Binding var blurScale : Double
    @Binding var showingAddScreen : Bool
    
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
        
        newItem.id    = UUID()
        newItem.name  = name
        newItem.type  = type
        newItem.price = Int16(price)
        newItem.image = inputImage!.pngData()
        newItem.discontinued = false
        newItem.tag   = "None"
        
        for newcolor in colorlist{
            if(newcolor != "")
            {
                let newItemColor = ItemColor(context: viewContext)
                
                newItemColor.id = UUID()
                newItemColor.colorName = newcolor
                
                for newsize in sizelist{
                    if(newsize != "")
                    {
                        let newItemSize = ItemSize(context: viewContext)
                        
                        newItemSize.id = UUID()
                        newItemSize.sizeName = newsize
                        newItemSize.inventory = 0
                        
                        newItemColor.addToColorSizes(newItemSize)
                    }
                }
                
                newItem.addToItemColors(newItemColor)
            }
        }
        
        for typeName in types{
            if(type == typeName.name!){
                typeName.typeCount = typeName.typeCount + 1
                break
            }
        }
        
        try? viewContext.save()
        dismiss()
    }
    
    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .stroke(Color(hex: findHex(color: "Pastel Orange", hexColors: hexColors))!, lineWidth: 5)
            .frame(width: 750, height: 600)
            .overlay(
                ZStack{
                    VStack{
                        HStack{
                            Text("Add New Item")
                                .font(Font.custom("LeagueSpartan-Bold", size: 32))
                                .padding(.leading)
                            
                            Spacer()
                            
                            Button{
                                blurScale = 0.0
                                showingAddScreen.toggle()
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
                            
                            Button{
                                saveItem()
                                blurScale = 0.0
                                showingAddScreen.toggle()
                            } label: {
                                RoundedRectangle(cornerRadius: 5)
                                    .fill(.green)
                                    .frame(width: 110, height: 40)
                                    .overlay(
                                        HStack{
                                            Text("Save Item")
                                                .font(Font.custom("LeagueSpartan", size: 20))
                                                .foregroundColor(.white)
                                                .padding(.leading, 10)
                                            Spacer()
                                        }
                                    )
                            }
                            .padding(.trailing)
                        }
                        .padding(.top)
                        
                        /*Item Name & Type/Item Colors Row */
                        HStack{
                            VStack(alignment: .leading){
                                
                                Text("Item Name, Type, & Price")
                                    .font(Font.custom("LeagueSpartan-Bold", size: 24))
                                    .padding(.leading, 5)
                                
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color(hex: findHex(color: "Pastel Orange", hexColors: hexColors))!)
                                    .opacity(0.1)
                                    .frame(width: 300, height: 30)
                                    .overlay(
                                        ZStack{
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(Color(hex: findHex(color: "Pastel Orange", hexColors: hexColors))!, lineWidth: 2)
                                            
                                            TextField("Item Name", text: $name)
                                             .font(Font.custom("LeagueSpartan", size: 14))
                                             .padding(.leading, 5)
                                        }
                                    )
                                
                                Text("Item Name")
                                    .font(Font.custom("LeagueSpartan-Bold", size: 10))
                                    .foregroundColor(.gray)
                                    .padding(.leading, 5)
                                
                                HStack{
                                    VStack(alignment: .leading){
                                        ZStack{
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(Color(hex: findHex(color: "Pastel Orange", hexColors: hexColors))!, lineWidth: 2)
                                                .frame(width: 190, height: 30)
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 10)
                                                        .fill(Color(hex: findHex(color: "Pastel Orange", hexColors: hexColors))!)
                                                        .opacity(0.1)
                                                )
                                            Picker("", selection: $type){
                                                ForEach(types.indices, id: \.self) { index in
                                                    Text("\(types[index].name!)")
                                                        .tag(types[index].name!)
                                                }
                                            }
                                            .frame(width: 190)
                                            
                                        }
                                        
                                        Text("Item Type")
                                            .font(Font.custom("LeagueSpartan-Bold", size: 10))
                                            .foregroundColor(.gray)
                                            .padding(.leading, 5)
                                    }
                                    
                                    VStack(alignment: .leading){
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color(hex: findHex(color: "Pastel Orange", hexColors: hexColors))!, lineWidth: 2)
                                            .frame(width: 100, height: 30)
                                            .overlay(
                                                ZStack{
                                                    RoundedRectangle(cornerRadius: 10)
                                                        .fill(Color(hex: findHex(color: "Pastel Orange", hexColors: hexColors))!)
                                                        .opacity(0.1)
                                                    TextField("Item Price", value: $price, format: .number)
                                                        .font(Font.custom("LeagueSpartan", size: 14))
                                                        .padding(.leading, 5)
                                                }
                                            )
                                        
                                        Text("Item Price")
                                            .font(Font.custom("LeagueSpartan-Bold", size: 10))
                                            .foregroundColor(.gray)
                                    }
                                }
                             
                                Text("Item Colors")
                                    .font(Font.custom("LeagueSpartan-Bold", size: 24))
                                    .padding(.top)
                                    .padding(.leading, 5)
                                
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color(hex: findHex(color: "Pastel Orange", hexColors: hexColors))!, lineWidth: 2)
                                    .frame(width: 250, height: 30)
                                    .overlay(
                                        ZStack{
                                            RoundedRectangle(cornerRadius: 10)
                                                .fill(Color(hex: findHex(color: "Pastel Orange", hexColors: hexColors))!)
                                                .opacity(0.1)
                                                .frame(width: 250, height: 30)
                                            TextField("Enter a Color", text: $onecolor)
                                                .onSubmit {
                                                    colorlist.append(onecolor)
                                                    
                                                    onecolor = ""
                                                }
                                                .font(Font.custom("LeagueSpartan", size: 12))
                                                .padding(.leading)
                                        }
                                    )
                                
                                Text("Color Name")
                                    .font(Font.custom("LeagueSpartan-Bold", size:10))
                                    .foregroundColor(.gray)
                                    .padding(.leading, 5)
                                
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color(hex: findHex(color: "Pastel Orange", hexColors: hexColors))!, lineWidth: 2)
                                    .frame(width: 250, height: 145)
                                    .overlay(
                                        ZStack{
                                            RoundedRectangle(cornerRadius: 10)
                                                .fill(Color(hex: findHex(color: "Pastel Orange", hexColors: hexColors))!)
                                                .opacity(0.1)
                                            VStack{
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
                                                                .font(Font.custom("LeagueSpartan-Bold", size: 16))
                                                                .padding(.top, 2)
                                                            
                                                            Spacer()
                                                            
                                                            Button{
                                                                colorlist.removeAll { $0 == addedcolor }
                                                            }label: {
                                                                Image(systemName: "trash.fill")
                                                                    .resizable()
                                                                    .frame(width: 15, height: 18)
                                                                    .foregroundColor(.red)
                                                            }
                                                        }
                                                        .frame(width: 230)
                                                    }
                                                }
                                                .onDelete(perform: deleteColor)
                                                Spacer()
                                            }
                                            .padding(.top, 10)
                                        }
                                    )
                                
                                Text("Submitted Colors")
                                    .font(Font.custom("LeagueSpartan-Bold", size: 10))
                                    .foregroundColor(.gray)
                                    .padding(.leading, 5)
                            }
                            .padding(.leading)
                            
                            Spacer()
                            
                            HStack{
                                VStack(alignment: .leading){
                                    Text("Item Image")
                                        .font(Font.custom("LeagueSpartan-Bold", size: 24))
                                    
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color(hex: findHex(color: "Pastel Orange", hexColors: hexColors))!, lineWidth: 2)
                                        .frame(width: 315, height: 350)
                                        .overlay(
                                            ZStack{
                                                if let image = inputImage {
                                                    Image(uiImage: image)
                                                        .resizable()
                                                        .frame(width: 310, height: 345)
                                                        .cornerRadius(10)
                                                }
                                                
                                                VStack(alignment: .leading){
                                                    HStack{
                                                        Spacer()
                                                        
                                                        Button{
                                                            self.showingImagePicker = true
                                                        } label:{
                                                            Image(systemName: "square.and.arrow.up.fill")
                                                                .resizable()
                                                                .frame(width: 23, height: 30)
                                                        }
                                                        .sheet(isPresented: $showingImagePicker) {
                                                            ImagePicker(image: self.$inputImage)
                                                        }
                                                    }
                                                    .padding(.trailing)
                                                    Spacer()
                                                }
                                                .padding(.top)
                                            }
                                        )
                                }
                                .padding(.trailing)
                                Spacer()
                            }
                            .padding(.leading)
                            .padding(.bottom)
                        }
                        
                        /* Item Sizes Row */
                        HStack{
                            VStack(alignment: .leading){
                                Text("Item Sizes")
                                    .font(Font.custom("LeagueSpartan-Bold", size: 24))
                                    .padding(.top)
                                    .padding(.leading, 5)
                                
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color(hex: findHex(color: "Pastel Orange", hexColors: hexColors))!, lineWidth: 2)
                                    .frame(width: 700, height: 50)
                                    .overlay(
                                        HStack{
                                            if(xsmall){
                                                RoundedRectangle(cornerRadius: 5)
                                                    .fill(Color(hex: findHex(color: "Pastel Orange", hexColors: hexColors))!)
                                                    .opacity(0.1)
                                                    .frame(width: 60, height: 30)
                                                    .overlay(
                                                        ZStack{
                                                            RoundedRectangle(cornerRadius: 5)
                                                                .stroke(Color(hex: findHex(color: "Pastel Orange", hexColors: hexColors))!, lineWidth: 2)
                                                            Toggle("XS", isOn: $xsmall)
                                                                .toggleStyle(.button)
                                                                .font(Font.custom("LeagueSpartan", size: 16))
                                                                .foregroundColor(.black)
                                                        }
                                                    )
                                            }else{
                                                RoundedRectangle(cornerRadius: 5)
                                                    .stroke(Color(hex: findHex(color: "Pastel Orange", hexColors: hexColors))!, lineWidth: 2)
                                                    .frame(width: 60, height: 30)
                                                    .overlay(
                                                        Toggle("XS", isOn: $xsmall)
                                                            .toggleStyle(.button)
                                                            .font(Font.custom("LeagueSpartan", size: 16))
                                                            .foregroundColor(.black)
                                                    )
                                            }
                                            
                                            if(small){
                                                RoundedRectangle(cornerRadius: 5)
                                                    .fill(Color(hex: findHex(color: "Pastel Orange", hexColors: hexColors))!)
                                                    .opacity(0.1)
                                                    .frame(width: 60, height: 30)
                                                    .overlay(
                                                        ZStack{
                                                            RoundedRectangle(cornerRadius: 5)
                                                                .stroke(Color(hex: findHex(color: "Pastel Orange", hexColors: hexColors))!, lineWidth: 2)
                                                            Toggle("SM", isOn: $small)
                                                                .toggleStyle(.button)
                                                                .font(Font.custom("LeagueSpartan", size: 16))
                                                                .foregroundColor(.black)
                                                        }
                                                    )
                                            }else{
                                                RoundedRectangle(cornerRadius: 5)
                                                    .stroke(Color(hex: findHex(color: "Pastel Orange", hexColors: hexColors))!, lineWidth: 2)
                                                    .frame(width: 60, height: 30)
                                                    .overlay(
                                                        Toggle("SM", isOn: $small)
                                                            .toggleStyle(.button)
                                                            .font(Font.custom("LeagueSpartan", size: 16))
                                                            .foregroundColor(.black)
                                                    )
                                            }
                                            
                                            if(medium){
                                                RoundedRectangle(cornerRadius: 5)
                                                    .fill(Color(hex: findHex(color: "Pastel Orange", hexColors: hexColors))!)
                                                    .opacity(0.1)
                                                    .frame(width: 60, height: 30)
                                                    .overlay(
                                                        ZStack{
                                                            RoundedRectangle(cornerRadius: 5)
                                                                .stroke(Color(hex: findHex(color: "Pastel Orange", hexColors: hexColors))!, lineWidth: 2)
                                                            Toggle("MD", isOn: $medium)
                                                                .toggleStyle(.button)
                                                                .font(Font.custom("LeagueSpartan", size: 16))
                                                                .foregroundColor(.black)
                                                        }
                                                    )
                                            }else{
                                                RoundedRectangle(cornerRadius: 5)
                                                    .stroke(Color(hex: findHex(color: "Pastel Orange", hexColors: hexColors))!, lineWidth: 2)
                                                    .frame(width: 60, height: 30)
                                                    .overlay(
                                                        Toggle("MD", isOn: $medium)
                                                            .toggleStyle(.button)
                                                            .font(Font.custom("LeagueSpartan", size: 16))
                                                            .foregroundColor(.black)
                                                    )
                                            }
                                                
                                            if(large){
                                                RoundedRectangle(cornerRadius: 5)
                                                    .fill(Color(hex: findHex(color: "Pastel Orange", hexColors: hexColors))!)
                                                    .opacity(0.1)
                                                    .frame(width: 60, height: 30)
                                                    .overlay(
                                                        ZStack{
                                                            RoundedRectangle(cornerRadius: 5)
                                                                .stroke(Color(hex: findHex(color: "Pastel Orange", hexColors: hexColors))!, lineWidth: 2)
                                                            Toggle("LG", isOn: $large)
                                                                .toggleStyle(.button)
                                                                .font(Font.custom("LeagueSpartan", size: 16))
                                                                .foregroundColor(.black)
                                                        }
                                                    )
                                            }else{
                                                RoundedRectangle(cornerRadius: 5)
                                                    .stroke(Color(hex: findHex(color: "Pastel Orange", hexColors: hexColors))!, lineWidth: 2)
                                                    .frame(width: 60, height: 30)
                                                    .overlay(
                                                        Toggle("LG", isOn: $large)
                                                            .toggleStyle(.button)
                                                            .font(Font.custom("LeagueSpartan", size: 16))
                                                            .foregroundColor(.black)
                                                    )
                                            }
                                            
                                            if(xlarge){
                                                RoundedRectangle(cornerRadius: 5)
                                                    .fill(Color(hex: findHex(color: "Pastel Orange", hexColors: hexColors))!)
                                                    .opacity(0.1)
                                                    .frame(width: 60, height: 30)
                                                    .overlay(
                                                        ZStack{
                                                            RoundedRectangle(cornerRadius: 5)
                                                                .stroke(Color(hex: findHex(color: "Pastel Orange", hexColors: hexColors))!, lineWidth: 2)
                                                            Toggle("XL", isOn: $xlarge)
                                                                .toggleStyle(.button)
                                                                .font(Font.custom("LeagueSpartan", size: 16))
                                                                .foregroundColor(.black)
                                                        }
                                                    )
                                            }else{
                                                RoundedRectangle(cornerRadius: 5)
                                                    .stroke(Color(hex: findHex(color: "Pastel Orange", hexColors: hexColors))!, lineWidth: 2)
                                                    .frame(width: 60, height: 30)
                                                    .overlay(
                                                        Toggle("XL", isOn: $xlarge)
                                                            .toggleStyle(.button)
                                                            .font(Font.custom("LeagueSpartan", size: 16))
                                                            .foregroundColor(.black)
                                                    )
                                            }
                                            
                                            if(xxlarge){
                                                RoundedRectangle(cornerRadius: 5)
                                                    .fill(Color(hex: findHex(color: "Pastel Orange", hexColors: hexColors))!)
                                                    .opacity(0.1)
                                                    .frame(width: 60, height: 30)
                                                    .overlay(
                                                        ZStack{
                                                            RoundedRectangle(cornerRadius: 5)
                                                                .stroke(Color(hex: findHex(color: "Pastel Orange", hexColors: hexColors))!, lineWidth: 2)
                                                            Toggle("XXL", isOn: $xxlarge)
                                                                .toggleStyle(.button)
                                                                .font(Font.custom("LeagueSpartan", size: 16))
                                                                .foregroundColor(.black)
                                                        }
                                                    )
                                            }else{
                                                RoundedRectangle(cornerRadius: 5)
                                                    .stroke(Color(hex: findHex(color: "Pastel Orange", hexColors: hexColors))!, lineWidth: 2)
                                                    .frame(width: 60, height: 30)
                                                    .overlay(
                                                        Toggle("XXL", isOn: $xxlarge)
                                                            .toggleStyle(.button)
                                                            .font(Font.custom("LeagueSpartan", size: 16))
                                                            .foregroundColor(.black)
                                                    )
                                            }
                                            
                                            if(xxxlarge){
                                                RoundedRectangle(cornerRadius: 5)
                                                    .fill(Color(hex: findHex(color: "Pastel Orange", hexColors: hexColors))!)
                                                    .opacity(0.1)
                                                    .frame(width: 60, height: 30)
                                                    .overlay(
                                                        ZStack{
                                                            RoundedRectangle(cornerRadius: 5)
                                                                .stroke(Color(hex: findHex(color: "Pastel Orange", hexColors: hexColors))!, lineWidth: 2)
                                                            Toggle("3XL", isOn: $xxxlarge)
                                                                .toggleStyle(.button)
                                                                .font(Font.custom("LeagueSpartan", size: 16))
                                                                .foregroundColor(.black)
                                                        }
                                                    )
                                            }else{
                                                RoundedRectangle(cornerRadius: 5)
                                                    .stroke(Color(hex: findHex(color: "Pastel Orange", hexColors: hexColors))!, lineWidth: 2)
                                                    .frame(width: 60, height: 30)
                                                    .overlay(
                                                        ZStack{
                                                            RoundedRectangle(cornerRadius: 5)
                                                                .stroke(Color(hex: findHex(color: "Pastel Orange", hexColors: hexColors))!, lineWidth: 2)
                                                            Toggle("3XL", isOn: $xxxlarge)
                                                                .toggleStyle(.button)
                                                                .font(Font.custom("LeagueSpartan", size: 16))
                                                                .foregroundColor(.black)
                                                        }
                                                    )
                                            }
                                            
                                            if(onesize){
                                                RoundedRectangle(cornerRadius: 5)
                                                    .fill(Color(hex: findHex(color: "Pastel Orange", hexColors: hexColors))!)
                                                    .opacity(0.1)
                                                    .frame(width: 100, height: 30)
                                                    .overlay(
                                                        ZStack{
                                                            RoundedRectangle(cornerRadius: 5)
                                                                .stroke(Color(hex: findHex(color: "Pastel Orange", hexColors: hexColors))!, lineWidth: 2)
                                                            Toggle("One Size", isOn: $onesize)
                                                                .toggleStyle(.button)
                                                                .font(Font.custom("LeagueSpartan", size: 16))
                                                                .foregroundColor(.black)
                                                        }
                                                    )
                                            }else{
                                                RoundedRectangle(cornerRadius: 5)
                                                    .stroke(Color(hex: findHex(color: "Pastel Orange", hexColors: hexColors))!, lineWidth: 2)
                                                    .frame(width: 100, height: 30)
                                                    .overlay(
                                                        Toggle("One Size", isOn: $onesize)
                                                            .toggleStyle(.button)
                                                            .font(Font.custom("LeagueSpartan", size: 16))
                                                            .foregroundColor(.black)
                                                    )
                                            }
                                            
                                        }
                                    )
                                
                                Text("Selected Sizes")
                                    .font(Font.custom("LeagueSpartan-Bold", size: 10))
                                    .foregroundColor(.gray)
                                    .padding(.leading, 5)
                                    .padding(.bottom)
                            }
                            .padding(.leading)
                            
                            Spacer()
                        }
                    }
                }
            )
    }
}


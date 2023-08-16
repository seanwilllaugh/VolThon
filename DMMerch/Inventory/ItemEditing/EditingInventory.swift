//
//  EditingInventory.swift
//  DMMerch
//
//  Created by Sean Laughlin on 7/27/23.
//

import SwiftUI

struct EditingInventory: View {
    @Environment(\.managedObjectContext) var viewContext
    @Environment(\.dismiss) var dismiss
    
    let hexColors = readColors()
    
    let gridLayout = [GridItem(.flexible()),GridItem(.flexible()),GridItem(.flexible()),GridItem(.flexible()),GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    let item: Item
    @Binding var editingInventory: Bool
    
    @State var sizeCount = 0
    @State private var itemSizeViewModels: [ItemSizeViewModel] = []
    
    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(Color(hex: findHex(color: "Pastel Orange", hexColors: hexColors))!)
            .opacity(0.1)
            .overlay(
                content
            )
            .onAppear {
                createViewModels()
            }
    }
    
    @ViewBuilder
    var content: some View {
        VStack(alignment: .leading) {
            gridHeader
            
            ScrollView {
                LazyVGrid(columns: gridLayout) {
                    ForEach(item.colorArray.indices, id: \.self) { colorIndex in
                        colorRow(for: item.colorArray[colorIndex])
                    }
                }
                .padding(.horizontal)
            }
            
            Spacer()
            
            saveButton
                .padding(.bottom)
        }
        .padding(.top)
        .padding(.leading)
    }
    
    var gridHeader: some View {
        Grid {
            GridRow {
                Text("Color")
                    .font(Font.custom("LeagueSpartan-Bold", size: 22))
                    .padding(.trailing)
                
                if let firstColor = item.colorArray.first {
                    ForEach(firstColor.sizeArray) { size in
                        RoundedRectangle(cornerRadius: 5)
                            .frame(width: 45, height: 45)
                            .foregroundColor(Color(hex: findHex(color: "Pastel Gray", hexColors: hexColors))!)
                            .overlay(
                                Text(size.sizeName!)
                                    .font(Font.custom("LeagueSpartan-Bold", size: 18))
                            )
                    }
                }
            }
        }
    }
    
    func colorRow(for color: ItemColor) -> some View {
        GridRow {
            Circle()
                .frame(width: 45, height: 45)
                .foregroundColor(Color(hex: findHex(color: color.colorName!, hexColors: hexColors))!)
                .padding(.trailing)
            
            ForEach(color.sizeArray.indices, id: \.self) { sizeIndex in
                if let viewModel = itemSizeViewModels.first(where: { $0.itemSize == color.sizeArray[sizeIndex] }) {
                    TextField("\(viewModel.inventory)", value: viewModel.binding(for: \.inventory), formatter: NumberFormatter())
                        .font(Font.custom("LeagueSpartan", size: 30))
                        .multilineTextAlignment(.center)
                        .keyboardType(.numberPad)
                }
            }
        }
    }
    
    var saveButton: some View {
        HStack {
            Spacer()
            Button(action: {
                try? viewContext.save()
                editingInventory = false
            }) {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color(hex: findHex(color: "Pastel Orange", hexColors: hexColors))!, lineWidth: 2)
                    .frame(width: 100, height: 40)
                    .padding(.trailing)
                    .padding(.top, 12)
                    .overlay(
                        Text("Save")
                            .font(Font.custom("LeagueSpartan", size: 22))
                            .padding(.top, 10)
                            .padding(.trailing)
                    )
            }
            Spacer()
        }
    }
    
    func createViewModels() {
        itemSizeViewModels = item.colorArray.flatMap { color in
            color.sizeArray.map { size in
                ItemSizeViewModel(itemSize: size)
            }
        }
    }
}

class ItemSizeViewModel: ObservableObject {
    let itemSize: ItemSize
    
    init(itemSize: ItemSize) {
        self.itemSize = itemSize
    }
    
    @Published var inventory: Int = 0 {
        didSet {
            // Update the CoreData entity when the inventory value changes
            itemSize.inventory = Int16(inventory)
            // Save the changes to the managed object context
            try? itemSize.managedObjectContext?.save()
        }
    }
    
    func binding<Value>(for keyPath: ReferenceWritableKeyPath<ItemSizeViewModel, Value>) -> Binding<Value> {
        Binding(get: { self[keyPath: keyPath] },
                set: { self[keyPath: keyPath] = $0 })
    }
}

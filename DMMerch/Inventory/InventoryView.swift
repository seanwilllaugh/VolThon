//
//  InventoryView.swift
//  DMMerch
//
//  Created by Sean Laughlin on 2/18/23.
//

import SwiftUI

struct InventoryView: View {
    @Environment(\.managedObjectContext) var viewContext
    @FetchRequest(sortDescriptors: [], animation: .default) var items: FetchedResults<Item>
    
    @State private var showingAddScreen = false
    @State private var showingFilters   = false
    
    let filters = ["Clothing", "Buttons", "Flowers", "Bags", "Stickers", "Bottles", "Other", "All"]
    @State var filter = "All"
    
    func deleteItem(at offsets: IndexSet) {
        for offset in offsets {
            let item = items[offset]
            
            viewContext.delete(item)
        }
        try? viewContext.save()
    }
    
    var body: some View {
        VStack{
            HStack{
                Button(){
                    filter = "Clothing"
                } label: {
                    Text("Clothes")
                        .foregroundColor(.white)
                        .frame(width: 90, height: 40)
                        .background(Rectangle())
                        .foregroundColor(.orange)
                        .shadow(radius: 5)
                        .cornerRadius(5)
                }
                .padding(.trailing)
                
                Button(){
                    filter = "Buttons"
                } label: {
                    Text("Buttons")
                        .foregroundColor(.white)
                        .frame(width: 90, height: 40)
                        .background(Rectangle())
                        .foregroundColor(.orange)
                        .shadow(radius: 5)
                        .cornerRadius(5)
                }
                .padding(.trailing)
                
                Button(){
                    filter = "Flowers"
                } label: {
                    Text("Flowers")
                        .foregroundColor(.white)
                        .frame(width: 90, height: 40)
                        .background(Rectangle())
                        .foregroundColor(.orange)
                        .shadow(radius: 5)
                        .cornerRadius(5)
                }
                .padding(.trailing)
                
                Button(){
                    filter = "Bags"
                } label: {
                    Text("Bags")
                        .foregroundColor(.white)
                        .frame(width: 90, height: 40)
                        .background(Rectangle())
                        .foregroundColor(.orange)
                        .shadow(radius: 5)
                        .cornerRadius(5)
                }
                .padding(.trailing)
                
                Button(){
                    filter = "Stickers"
                } label: {
                    Text("Stickers")
                        .foregroundColor(.white)
                        .frame(width: 90, height: 40)
                        .background(Rectangle())
                        .foregroundColor(.orange)
                        .shadow(radius: 5)
                        .cornerRadius(5)
                }
                .padding(.trailing)
                
                Button(){
                    filter = "Bottles"
                } label: {
                    Text("Bottles")
                        .foregroundColor(.white)
                        .frame(width: 90, height: 40)
                        .background(Rectangle())
                        .foregroundColor(.orange)
                        .shadow(radius: 5)
                        .cornerRadius(5)
                }
                .padding(.trailing)
                
                Button(){
                    filter = "Other"
                } label: {
                    Text("Other")
                        .foregroundColor(.white)
                        .frame(width: 90, height: 40)
                        .background(Rectangle())
                        .foregroundColor(.orange)
                        .shadow(radius: 5)
                        .cornerRadius(5)
                }
                
            }
            
            Button(){
                filter = "All"
            } label: {
                Text("Clear Filter")
                    .foregroundColor(.white)
                    .frame(width: 180, height: 40)
                    .background(Rectangle())
                    .foregroundColor(.orange)
                    .shadow(radius: 5)
                    .cornerRadius(5)
            }
            
            Divider()
                .frame(height: 1)
                .padding(.horizontal, 30)
                .background(Color.black)
            
            ScrollView{
                if(filter == "All")
                {
                    ForEach(items) { item in
                        NavigationLink{
                            DetailView(item: item)
                        } label: {
                            InventoryRow(item: item).preferredColorScheme(.light)
                                .frame(width:832, height: 60)
                                .foregroundColor(.white)
                                .cornerRadius(5)
                        }
                        Divider()
                            .frame(height: 1)
                            .padding(.horizontal, 30)
                            .background(Color.black)
                    }
                    .onDelete(perform: deleteItem)
                }else{
                    ForEach(items) { item in
                        if(item.type == filter){
                            NavigationLink{
                                DetailView(item: item)
                            } label: {
                                InventoryRow(item: item).preferredColorScheme(.light)
                                    .frame(width:832, height: 60)
                                    .foregroundColor(.white)
                                    .cornerRadius(5)
                            }
                            Divider()
                                .frame(height: 1)
                                .padding(.horizontal, 30)
                                .background(Color.black)
                        }
                    }
                    .onDelete(perform: deleteItem)
                }
            }
            .navigationTitle("Available Merch: \(filter)")
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button{
                        showingAddScreen.toggle()
                    } label: {
                        Label("Add Item", systemImage: "plus")
                    }
                }
                ToolbarItem() {
                    Button{
                        showingFilters.toggle()
                    } label: {
                        Label("Filter", systemImage: "line.3.horizontal.circle")
                    }
                }
            }
            .sheet(isPresented: $showingAddScreen) {
                AddItemView().preferredColorScheme(.light)
            }
        }
        .background(
            Image("Background")
                .resizable()
                .scaledToFit()
                .frame(width: 1300, height: 800)
                .offset(y:-45)
        )
        
    }
}

struct InventoryView_Previews: PreviewProvider {
    static var previews: some View {
        InventoryView()
    }
}

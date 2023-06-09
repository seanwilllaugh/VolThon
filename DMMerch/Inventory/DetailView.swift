//
//  DetailView.swift
//  DMMerch
//
//  Created by Sean Laughlin on 2/17/23.
//

import SwiftUI
import CoreData
import Foundation

struct DetailView: View {
    @Environment(\.managedObjectContext) var viewContext
    @Environment(\.dismiss) var dismiss
    
    @State var cell  = ["0", "1"]
    
    @State private var showingDeleteAlert = false
    @State private var showingEditScreen = false
    
    let item: Item
    @State var Colors = [String]()
    @State var Sizes  = [String]()
    @State var image  = UIImage()
    
    let hexColors = readColors()
    
    func deleteBook() {
        viewContext.delete(item)

        // try? moc.save() // uncomment this line to make the deletion permanent
        dismiss()
    }
    
    func loadImage()->UIImage{
        guard UIImage(data: item.image!) != nil else{
            return UIImage(imageLiteralResourceName: "FTKShirt")
        }
        
        return UIImage(data: item.image!)!
    }
    
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
        VStack() {
            HStack{
                Text(item.name!)
                    .font(.system(size: 42))
                    .fontWeight(.bold)
                    .padding(.leading)
                Text("$\(item.price)")
                    .font(.system(size:32))
                    .fontWeight(.light)
                Spacer()
            }
            .offset(y: -100)
            
            HStack{
                Text(item.type!)
                    .fontWeight(.semibold)
                    .padding(.leading)
                Spacer()
            }
            .offset(y: -100)
            
            HStack{
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(Rectangle())
                    .overlay{
                        Rectangle().stroke(.white, lineWidth: 7)
                    }
                    .frame(width: 350, height: 350)
                    .offset(y: -105)
                    .shadow(radius: 5)
                    .padding(.leading)
                
                Spacer()
                
                VStack{
                    Text("Available Colors")
                        .padding(.leading)
                        .font(.system(size: 24))
                        .fontWeight(.semibold)
                        .offset(x: -8, y: -115)
                    ForEach(Colors, id: \.self){ color in
                        HStack{
                            Circle()
                                .frame(width:25, height:25)
                                .shadow(radius: 5)
                                .foregroundColor(Color(hex: findHex(color: color, hexColors: hexColors)) ?? .black)
                                .offset(y: -115)
                                .padding(.leading, 30)
                                .padding(.trailing)
                            Text(color)
                                .offset(y: -115)
                            Spacer()
                        }
                        .frame(width:200, alignment: .leading)
                    }
                }
                .frame(width: 200, height: 310, alignment: .top)
                .padding(.leading)
                .padding(.trailing)
                
                Spacer()
                
                VStack{
                    Text("Sizes")
                        .padding(.leading)
                        .font(.system(size: 24))
                        .fontWeight(.semibold)
                        .offset(x: -8, y: -115)
                    ForEach(Sizes, id: \.self){ size in
                        Text(size)
                            .offset(y: -115)
                            .padding(.leading)
                    }
                }
                .frame(width: 200, height: 310, alignment: .top)
                .padding(.trailing)
                Spacer()
            }
            
            Text("Inventory")
                .fontWeight(.bold)
                .underline()
                .offset(y:-105)
                .frame(width: 845, alignment: .leading)
            
            
            
        }
        .navigationTitle(item.name!)
        .background(Image("Background"))
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(perform: {
            Colors = seperateColors()
            Sizes  = seperateSizes()
            image = loadImage()
        })
        .alert("Delete Item", isPresented: $showingDeleteAlert) {
            Button("Delete", role: .destructive, action: deleteBook)
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Are you sure?")
        }
        .toolbar {
            Button {
                showingDeleteAlert = true
            } label: {
                Label("Delete this item", systemImage: "trash")
            }
            Button{
                showingEditScreen.toggle()
            } label: {
                Label("Edit Item", systemImage: "pencil")
            }
        }
        .sheet(isPresented: $showingEditScreen) {
            EditItemView(item : item).preferredColorScheme(.light)
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static let viewContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)

        static var previews: some View {
            let item = Item(context: viewContext)

            return NavigationView {
                DetailView(item: item)
            }
        }
}

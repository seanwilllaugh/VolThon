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
    @FetchRequest(sortDescriptors: [SortDescriptor(\.typeCount, order: .reverse)], animation: .default) var types: FetchedResults<ItemType>
    
    @State var cell  = ["0", "1"]
    
    @State private var showingDeleteAlert = false
    @State private var showingEditScreen = false
    
    let item: Item
    @State var Colors = [String]()
    @State var Sizes  = [String]()
    @State var image  = UIImage()
    
    let hexColors = readColors()
    
    func deleteBook() {
        for type in types{
            if(item.type == type.name){
                type.typeCount = type.typeCount - 1
                break
            }
        }
        
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
            
            HStack{
                Text(item.type!)
                    .fontWeight(.semibold)
                    .padding(.leading)
                Spacer()
            }
            
            HStack(alignment:.top){
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(Rectangle())
                    .overlay{
                        Rectangle().stroke(.white, lineWidth: 7)
                    }
                    .frame(width: 350)
                    .frame(maxHeight: 300)
                    .shadow(radius: 5)
                    .padding(.leading)
                    .padding(.top)
                
                Spacer()
                
                RoundedRectangle(cornerRadius: 5)
                    .fill(.gray)
                    .frame(width: 450, height: 300)
                    .overlay{
                        VStack(alignment: .center){
                            Text("Available Colors")
                                .padding(.top)
                                .font(.system(size: 24))
                                .fontWeight(.semibold)
                                .fontDesign(.rounded)
                            ForEach(Colors, id: \.self){ color in
                                HStack{
                                    Circle()
                                        .frame(width:25, height:25)
                                        .shadow(radius: 5)
                                        .foregroundColor(Color(hex: findHex(color: color, hexColors: hexColors)) ?? .black)
                                        .padding(.trailing)
                                    Text(color)
                                        .font(.system(size: 16))
                                        .fontDesign(.rounded)
                                        .frame(width: 100, alignment: .center)
                                }
                                .frame(width: 150)
                                //.border(.red)
                            }
                            
                            Spacer()
                            
                            VStack{
                                Text("Sizes")
                                    .padding(.top)
                                    .font(.system(size: 24))
                                    .fontWeight(.semibold)
                                    .fontDesign(.rounded)
                                HStack{
                                    ForEach(Sizes, id: \.self){ size in
                                        Text(size)
                                            .font(.system(size: 16))
                                            .fontDesign(.rounded)
                                    }
                                }
                            }
                            .frame(height: 75)
                            .padding(.bottom)
                        }
                    }
                    .padding(.top)
                
                Spacer()
            }
            
            Spacer()
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

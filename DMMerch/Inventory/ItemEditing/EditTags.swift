//
//  EditTags.swift
//  DMMerch
//
//  Created by Sean Laughlin on 8/1/23.
//

import SwiftUI

struct EditTags: View {
    @Environment(\.managedObjectContext) var viewContext
    var item: Item
    
    let hexColors = readColors()
    
    @Binding var editingTags : Bool
    
    @State private var newTag     = ""
    @State private var tagList    = [""]
    
    func saveTags(){
        item.tag! = "None"
        
        for tag in tagList{
            if(tag != "")
            {
                item.tag!.append(",\(tag)")
            }
        }
        
        try? viewContext.save()
    }
    
    func deleteTag(at offsets: IndexSet){
        for offset in offsets {
            tagList[offset] = ""
        }
    }
    
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 20)
                .fill(.white)
                .frame(width: 600, height: 450)
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(hex: findHex(color: "Pastel Orange", hexColors: hexColors))!)
                .opacity(0.1)
                .frame(width: 600, height: 450)
                .overlay(
                    ZStack{
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color(hex: findHex(color: "Pastel Orange", hexColors: hexColors))!, lineWidth: 5)
                        
                        VStack{
                            HStack{
                                Text("Edit Tags")
                                    .font(Font.custom("LeagueSpartan-Bold", size: 36))
                                
                                Spacer()
                            }
                            .padding(.top)
                            
                            Spacer()
                            
                            ZStack{
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color(hex: findHex(color: "Tag Gray", hexColors: hexColors))!)
                                    .frame(width: 550,height: 35)
                                
                                TextField("Enter a New Tag", text: $newTag)
                                    .onSubmit{
                                        tagList.append(newTag)
                                        
                                        newTag = ""
                                    }
                                    .offset(x: 15)
                            }
                            
                            Spacer()
                            
                            ZStack{
                                if(tagList.count.self == 1){
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(.white)
                                        .frame(width: 450, height: 250)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 20)
                                                .stroke(.black, lineWidth: 5)
                                        )
                                }else{
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(Color(hex: findHex(color: "Tag Gray", hexColors: hexColors))!)
                                        .frame(width: 450, height: 250)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 20)
                                                .stroke(.black, lineWidth: 5)
                                        )
                                }
                                
                                List{
                                    ForEach(tagList, id: \.self){ tag in
                                        if(tag != "")
                                        {
                                            if(tag != "None"){
                                                HStack{
                                                    Text(tag)
                                                        .font(Font.custom("LeagueSpartan", size: 16))
                                                    
                                                    
                                                    Spacer()
                                                    
                                                    Text("Swipe to Delete")
                                                        .font(Font.custom("LeagueSpartan", size: 8))
                                                        .foregroundColor(.gray)
                                                }
                                            }
                                        }
                                    }
                                    .onDelete(perform: deleteTag)
                                }
                                .frame(width: 420, height: 240)
                            }
                            
                            Spacer()
                            
                            Button{
                                saveTags()
                                editingTags = false
                            } label: {
                                ZStack{
                                    RoundedRectangle(cornerRadius: 5)
                                        .fill(Color(hex: findHex(color: "Pastel Orange", hexColors: hexColors))!)
                                        .frame(width: 150, height: 50)
                                    
                                    Text("Save Tags")
                                        .font(Font.custom("LeagueSpartan-Bold", size: 24))
                                        .foregroundColor(.black)
                                }
                            }
                            .padding(.bottom)
                        }
                        .padding(.leading)
                        .padding(.trailing)
                    }
                )
        }
        .onAppear{
            let separatedTags = item.tag!.split(separator: ",")
            
            for tag in separatedTags{
                tagList.append("\(tag)")
            }
        }
    }
}

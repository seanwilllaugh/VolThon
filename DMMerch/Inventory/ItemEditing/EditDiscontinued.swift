//
//  EditDiscontinued.swift
//  DMMerch
//
//  Created by Sean Laughlin on 8/1/23.
//

import SwiftUI

struct EditDiscontinued: View {
    @Environment(\.managedObjectContext) var viewContext
    var item: Item
    
    let hexColors = readColors()
    
    @Binding var editingDiscontinued : Bool
    
    @State private var discontinueToggle = false
    @State private var discontinueDateSelection = Date()
    
    func saveDisc(){
        item.discontinued = discontinueToggle
        item.discontinuedDate = discontinueDateSelection
        
        try? viewContext.save()
    }
    
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 20)
                .fill(.white)
                .frame(width: 350, height: 200)
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(hex: findHex(color: "Pastel Orange", hexColors: hexColors))!)
                .opacity(0.1)
                .frame(width: 350, height: 200)
                .overlay(
                    ZStack{
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color(hex: findHex(color: "Pastel Orange", hexColors: hexColors))!, lineWidth: 5)
                        
                        VStack{
                            HStack{
                                Text("Discontinuation Info")
                                    .font(Font.custom("LeagueSpartan-Bold", size: 28))
                                
                                Spacer()
                            }
                            .padding(.top)
                            
                            Spacer()
                            
                            Toggle("Discontinue Switch", isOn: $discontinueToggle)
                            
                            DatePicker("Discontinue Date", selection: $discontinueDateSelection, displayedComponents: .date)
                            
                            Button{
                                saveDisc()
                                editingDiscontinued = false
                            } label: {
                                ZStack{
                                    RoundedRectangle(cornerRadius: 5)
                                        .fill(Color(hex: findHex(color: "Pastel Orange", hexColors: hexColors))!)
                                        .frame(width: 100, height: 35)
                                    
                                    Text("Save")
                                        .font(Font.custom("LeagueSpartan-Bold", size: 18))
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
            discontinueToggle = item.discontinued
            
            if(item.discontinued){
                discontinueDateSelection = item.discontinuedDate!
            }
        }
    }
}


//
//  FiltersView.swift
//  DMMerch
//
//  Created by Sean Laughlin on 3/7/23.
//

import SwiftUI

struct FiltersView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var clothing = false
    @State private var button   = false
    @State private var flower   = false
    @State private var sticker  = false
    @State private var bag      = false
    @State private var bottle   = false
    @State private var other    = false
    @State private var none     = false
    
    @State var filterString : String
    
    func returnFilter(){
        
        if(clothing){
            filterString = "Clothing"
        }
        if(button){
            filterString = "Button"
        }
        if(flower){
            filterString = "Flower"
        }
        if(sticker){
            filterString = "Sticker"
        }
        if(bag){
            filterString = "Bag"
        }
        if(bottle){
            filterString = "Water Bottle"
        }
        if(other){
            filterString = "Other"
        }
        if(none){
            filterString = "None"
        }
    
        dismiss()
    }
    
    var body: some View {
        NavigationView{
            Form{
                Section(header: Text("Filter")){
                    Toggle("Clothing", isOn: $clothing)
                        .toggleStyle(.button)
                    Toggle("Buttons", isOn: $button)
                        .toggleStyle(.button)
                    Toggle("Flowers", isOn: $flower)
                        .toggleStyle(.button)
                    Toggle("Stickers", isOn: $sticker)
                        .toggleStyle(.button)
                    Toggle("Bags", isOn: $bag)
                        .toggleStyle(.button)
                    Toggle("Bottles", isOn: $bottle)
                        .toggleStyle(.button)
                    Toggle("Other", isOn: $other)
                        .toggleStyle(.button)
                    Toggle("None", isOn: $none)
                        .toggleStyle(.button)
                    
                    Section(){
                        Button(){
                            returnFilter()
                        } label: {
                            Text("Filter")
                        }
                    }
                }
            }
        }
    }
}

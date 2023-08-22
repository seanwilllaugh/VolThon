//
//  TransactionDetailView.swift
//  DMMerch
//
//  Created by Sean Laughlin on 2/20/23.
//

import SwiftUI

struct TransactionDetailView: View {
    @Environment(\.managedObjectContext) var viewContext
    @Environment(\.dismiss) var dismiss
    
    @State private var showingDeleteAlert = false
    
    let hexColors = readColors()
    
    let transaction: Purchase
    
    func deleteBook() {
        viewContext.delete(transaction)

        // try? moc.save() // uncomment this line to make the deletion permanent
        dismiss()
    }
    
    var body: some View {
        VStack() {
            HStack{
                ZStack{
                    if(transaction.method! == "Venmo")
                    {
                        Circle()
                            .foregroundColor(.blue)
                            .frame(width: 80, height: 80)
                            .shadow(radius: 5)
                            .padding(.leading)
                    }
                    
                    if(transaction.method! == "Cash")
                    {
                        Circle()
                            .foregroundColor(.green)
                            .frame(width: 80, height: 80)
                            .shadow(radius: 5)
                            .padding(.leading)
                    }
                    
                    if(transaction.method! == "DonorDrive")
                    {
                        Circle()
                            .foregroundColor(.purple)
                            .frame(width: 80, height: 80)
                            .shadow(radius: 5)
                            .padding(.leading)
                    }
                    
                    Text("$\(transaction.totalPrice)")
                        .foregroundColor(.white)
                        .font(.system(size: 30))
                        .padding(.leading)
                }
                
                Text(transaction.buyer!)
                    .font(.system(size: 42))
                    .fontWeight(.bold)
                    .padding(.leading)
                
                Text("\(transaction.purchaseTime ?? "n/a")")
                    .offset(y:9)
                
                Spacer()
                
                VStack{
                    Button(){
                        
                    } label: {
                        Text("Contact")
                            .frame(width:150, height:50)
                            .foregroundColor(.white)
                            .background(Rectangle())
                            .cornerRadius(5)
                            .shadow(radius: 10)
                            .foregroundColor(.orange)
                            .padding(.top)
                            .padding(.trailing)
                    }
                    
                    Text(transaction.phone ?? "n/a")
                        .font(.system(size: 20))
                        .fontWeight(.light)
                        .padding(.trailing)
                    
                    Text(transaction.email ?? "n/a")
                            .font(.system(size: 14))
                            .fontWeight(.light)
                            .padding(.trailing)
                    
                }
                .padding(.trailing)
            }
            
            HStack{
                Text("Items Purchased:")
                    .font(Font.custom("LeagueSpartan-Bold", size: 38))
                    .padding(.leading)
                
                Spacer()
            }
            .padding(.top)
            
            RoundedRectangle(cornerRadius: 20)
                .fill(.white)
                .frame(width: 850, height: 65)
                .overlay(
                    HStack{
                        Text("Quantity")
                            .font(Font.custom("LeagueSpartan-Bold", size: 28))
                            .padding(.leading)
                            .frame(width: 135)
                        
                        Text("Item")
                            .font(Font.custom("LeagueSpartan-Bold", size: 28))
                            .frame(width: 200)
                        
                        Text("Color")
                            .font(Font.custom("LeagueSpartan-Bold", size: 28))
                            .frame(width: 200)
                        
                        Text("Size")
                            .font(Font.custom("LeagueSpartan-Bold", size: 28))
                            .frame(width: 200)
                        
                        Text("Cost")
                            .font(Font.custom("LeagueSpartan-Bold", size: 28))
                            .padding(.trailing)
                            .frame(width: 115)
                    }
                )
            
            let allUnformattedItems = String(transaction.items!).split(separator: ";")
            ScrollView{
                ForEach(allUnformattedItems, id: \.self){ item in
                    let oneUnformattedItem = item.split(separator: ",")
                    
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color(hex: findHex(color: "Pastel Orange", hexColors: hexColors))!)
                        .opacity(0.1)
                        .frame(width: 850, height: 65)
                        .overlay(
                            HStack{
                                Text("\(String(oneUnformattedItem[0]))")
                                    .padding(.leading)
                                    .font(Font.custom("LeagueSpartan-Bold", size: 28))
                                    .frame(width: 135)
                                
                                Text(oneUnformattedItem[1])
                                    .font(Font.custom("LeagueSpartan-Bold", size: 24))
                                    .frame(width: 200)
                                
                                HStack{
                                    Circle()
                                        .foregroundColor(Color(hex: findHex(color: String(oneUnformattedItem[2]), hexColors: hexColors)) ?? .black)
                                        .frame(width: 30, height: 30)
                                    
                                    Text(oneUnformattedItem[2])
                                        .foregroundColor(.black)
                                        .font(Font.custom("LeagueSpartan-Bold", size: 24))
                                }
                                .frame(width: 200)
                                
                                Text("\(String(oneUnformattedItem[3]))")
                                    .font(Font.custom("LeagueSpartan-Bold", size: 24))
                                    .frame(width: 200)
                                
                                Text("$20")
                                    .font(Font.custom("LeagueSpartan-Bold", size: 24))
                                    .padding(.trailing)
                                    .frame(width: 115)
                            }
                        )
                }
                Spacer()
            }
            
            Spacer()
        }
        .navigationTitle("Transaction Details")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(perform: {

        })
        .alert("Delete Transactipon", isPresented: $showingDeleteAlert) {
            Button("Delete", role: .destructive, action: deleteBook)
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Are you sure?")
        }
        .toolbar {
            Button {
                showingDeleteAlert = true
            } label: {
                Label("Delete this transaction", systemImage: "trash")
            }
        }
    }
}

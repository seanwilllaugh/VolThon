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

        // twry? moc.save() // uncomment this line to make the deletion permanent
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
                    
                    Text("$\(transaction.totalPrice)")
                        .foregroundColor(.white)
                        .font(.system(size: 30))
                        .padding(.leading)
                }
                
                Text(transaction.buyer!)
                    .font(.system(size: 42))
                    .fontWeight(.bold)
                    .padding(.leading)
                
                Text("\(transaction.purchaseTime)")
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
                    if(transaction.phone == "")
                    {
                        Text("Unknown Phone")
                            .font(.system(size:20))
                            .fontWeight(.light)
                            .padding(.trailing)
                    }else{
                        Text(transaction.phone)
                            .font(.system(size: 20))
                            .fontWeight(.light)
                            .padding(.trailing)
                    }
                    if(transaction.email == "")
                    {
                        Text("Unknown Email")
                            .font(.system(size: 14))
                            .fontWeight(.light)
                            .padding(.trailing)
                    }else{
                        Text(transaction.email)
                            .font(.system(size: 14))
                            .fontWeight(.light)
                            .padding(.trailing)
                    }
                }
                .padding(.trailing)
            }
            
            Text("Items Purchased:")
                .font(.system(size: 36))
                .fontWeight(.bold)
                .padding(.top)
                .frame(width: 850, alignment: .leading)
            
            let allUnformattedItems = String(transaction.items!).split(separator: ";")
            ScrollView{
                ForEach(allUnformattedItems, id: \.self){ item in
                    let oneUnformattedItem = item.split(separator: ",")
                    HStack{
                        Text("Qty: \(String(oneUnformattedItem[0]))")
                            .fixedSize()
                            .foregroundColor(.black)
                            .shadow(radius: 2)
                            .frame(width: 100, height: 45, alignment: .center)
                            .cornerRadius(5)
                            .padding(.leading)
                            .foregroundColor(.white)
                            .font(.system(size: 28))
                            .offset(x: 5, y: 10)
                        
                        VStack{
                            Text(oneUnformattedItem[1])
                                .fixedSize()
                                .fontWeight(.bold)
                                .frame(width: 150, alignment: .center)
                                .offset(y: 15)
                            
                            Image("FTKShirt")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .clipShape(Rectangle())
                                .cornerRadius(5)
                                .frame(width: 100, height: 100)
                                .shadow(radius: 5)
                        }
                        VStack{
                            Spacer()
                            HStack{
                                Text("Color :")
                                    .foregroundColor(.black)
                                    .font(.system(size:22))
                                    .shadow(radius: 2)
                                    .padding(.leading)
                                //.offset(y: 10)
                                
                                Circle()
                                    .foregroundColor(Color(hex: findHex(color: String(oneUnformattedItem[2]), hexColors: hexColors)) ?? .black)
                                    .frame(width: 30, height: 30)
                                    .shadow(radius: 5)
                                //.offset(y: 10)
                                
                                Text(oneUnformattedItem[2])
                                    .foregroundColor(.black)
                                    .fixedSize()
                                    .font(.system(size: 22))
                                    .shadow(radius: 2)
                                    .frame(width: 300, alignment: .leading)
                                //.offset(y: 10)
                            }
                            .background(
                                Rectangle()
                                    .cornerRadius(8)
                                    .frame(width: 400, height: 45)
                                    .shadow(radius: 5)
                            )
                            .foregroundColor(.white)
                            
                            Text("Size   : \(String(oneUnformattedItem[3]))")
                                .fixedSize()
                                .shadow(radius: 2)
                                .padding(.leading, 8)
                                .foregroundColor(.black)
                                .font(.system(size: 22))
                                .frame(width: 400, height: 45, alignment: .leading)
                                .background(
                                    Rectangle()
                                        .cornerRadius(8)
                                        .shadow(radius: 5)
                                )
                                .foregroundColor(.white)
                        }
                        .offset(y: -7)
                        Spacer()
                    }
                }
                .background(
                    Rectangle()
                        .foregroundColor(.white)
                        .cornerRadius(15)
                        .frame(width: 850, height: 130)
                        .shadow(radius: 5)
                        .offset(y:12.5)
                )
                Spacer()
            }
        }
        .navigationTitle("Transaction Details")
        .navigationBarTitleDisplayMode(.inline)
        .background(
            Image("Background")
                .resizable()
                .scaledToFit()
                .frame(width: 1300, height: 800)
                .offset(y:-30)
        )
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

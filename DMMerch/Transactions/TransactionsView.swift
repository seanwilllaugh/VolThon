//
//  TransactionsView.swift
//  DMMerch
//
//  Created by Sean Laughlin on 2/18/23.
//

import SwiftUI

struct TransactionsView: View {
    @Environment(\.managedObjectContext) var viewContext
    @FetchRequest(sortDescriptors: [], animation: .default) var purchases: FetchedResults<Purchase>
    
    @State private var showingAddScreen = false
    
    func deleteItem(at offsets: IndexSet) {
        for offset in offsets {
            let purchase = purchases[offset]
            
            viewContext.delete(purchase)
        }
        try? viewContext.save()
    }
    
    var body: some View {
        List{
            ForEach(purchases) { purchase in
                NavigationLink{
                    TransactionDetailView(transaction: purchase).preferredColorScheme(.light)
                } label: {
                    HStack{
                        ZStack{
                            if(purchase.method! == "Venmo")
                            {
                                Circle()
                                    .foregroundColor(.blue)
                                    .frame(width: 45, height: 45)
                                    .shadow(radius: 5)
                            }
                            
                            if(purchase.method! == "Cash")
                            {
                                Circle()
                                    .foregroundColor(.green)
                                    .frame(width: 45, height: 45)
                                    .shadow(radius: 5)
                            }
                            
                            Text("$\(purchase.totalPrice)")
                                .foregroundColor(.white)
                        }
                        
                        Text(purchase.buyer ?? "Unknown Buyer")
                            .font(.system(size: 24))
                            .fontWeight(.bold)
                        
                        Text(purchase.purchaseTime ?? "N/A")
                            .padding(.top, 5)
                        
                        Spacer()
                        
                        Text("\(purchase.totalItems) Items")
                            .font(.system(size:20))
                            .fontWeight(.light)
                            .foregroundColor(.gray)

                    }
                }
            }
            .onDelete(perform: deleteItem)
        }
        .navigationTitle("Recent Transactions")
        .background(
            Image("Background")
                .resizable()
                .scaledToFit()
                .frame(width: 1300, height: 800)
                .offset(y:-35)
        )
        .toolbar{
            ToolbarItem(placement: .navigationBarTrailing) {
                EditButton()
            }
        }
    }
}

struct TransactionsView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionsView()
    }
}

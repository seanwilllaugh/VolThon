//
//  NewPurchaseView.swift
//  DMMerch
//
//  Created by Sean Laughlin on 2/18/23.
//

import SwiftUI

struct NewPurchaseView: View {
    @Environment(\.managedObjectContext) var viewContext
    @FetchRequest(sortDescriptors: [], animation: .default) var items: FetchedResults<Item>
    
    @State private var showingCompleteScreen = false
    
    @State var Cart = [cartItem]()
    
    var body: some View {
        VStack{
            ScrollView{
                ForEach(items){ item in
                    PurchaseRow(item: item, Cart: $Cart).preferredColorScheme(.light)
                        .frame(width: 900, height: 60)
                        .foregroundColor(.white)
                        .cornerRadius(5)
                    Divider()
                        .frame(height: 1)
                        .padding(.horizontal, 30)
                        .background(Color.black)
                }
            }
            
            Button(){
                showingCompleteScreen.toggle()
            } label: {
                Text("Checkout")
                    .fixedSize()
                    .fontWeight(.semibold)
                    .font(.system(size: 36))
                    .foregroundColor(Color.white)
                    .frame(width: 400, height:100)
                    .background(Rectangle())
                    .foregroundColor(.orange)
                    .cornerRadius(15)
            }
            
            .sheet(isPresented: $showingCompleteScreen){
                CompletePurchaseView(Cart : $Cart).preferredColorScheme(.light)
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

struct NewPurchaseView_Previews: PreviewProvider {
    static var previews: some View {
        NewPurchaseView()
    }
}

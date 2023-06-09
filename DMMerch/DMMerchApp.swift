//
//  DMMerchApp.swift
//  DMMerch
//
//  Created by Sean Laughlin on 2/16/23.
//

import SwiftUI

@main
struct DMMerchApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

//
//  DoDoneApp.swift
//  DoDone
//
//  Created by Mac on 13/08/2024.
//

import SwiftUI

@main
struct DoDoneApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

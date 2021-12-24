//
//  ExampleCoreDataApp.swift
//  ExampleCoreData
//
//  Created by Алексей Сухов on 24.12.2021.
//

import SwiftUI

@main
struct ExampleCoreDataApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

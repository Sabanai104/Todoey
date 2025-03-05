//
//  TodoeyApp.swift
//  Todoey
//
//  Created by Gabriel Sabanai on 27/11/24.
//

import SwiftUI

@main
struct TodoeyApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

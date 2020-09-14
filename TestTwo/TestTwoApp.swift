//
//  TestTwoApp.swift
//  TestTwo
//
//  Created by Jan Hovland on 14/09/2020.
//

import SwiftUI

@main
struct TestTwoApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

//
//  LocalizatorApp.swift
//  Localizator
//
//  Created by Aleksey Pleshkov on 07.02.2025.
//

import SwiftUI

@main
struct LocalizatorApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(width: 350, height: 300)
                .containerBackground(.thinMaterial, for: .window)
                .toolbarBackgroundVisibility(.hidden, for: .windowToolbar)
        }
        .windowResizability(.contentSize)
        .windowBackgroundDragBehavior(.enabled)
    }
}

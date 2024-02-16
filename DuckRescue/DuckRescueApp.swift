//
//  DuckRescueApp.swift
//  DuckRescue
//
//  Created by Felix Parey on 13/02/24.
//

import SwiftUI

@main
struct DuckRescueApp: App {
    
    @State private var appState = AppState()
    
    var body: some Scene {
        WindowGroup(id: "Start") {
            StartScreen()
                .environment(appState)
                .frame(width: 1000, height: 600)
                .fixedSize(horizontal: true, vertical: true)
        }
        .defaultSize(width: 1000, height: 600)
        .windowResizability(.contentSize)
        

        ImmersiveSpace(id: "ImmersiveSpace") {
            ImmersiveView()
        }
        .environment(appState)
    }
}

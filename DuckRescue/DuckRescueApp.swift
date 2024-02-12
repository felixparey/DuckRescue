//
//  DuckRescueApp.swift
//  DuckRescue
//
//  Created by Felix Parey on 13/02/24.
//

import SwiftUI

@main
struct DuckRescueApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }

        ImmersiveSpace(id: "ImmersiveSpace") {
            ImmersiveView()
        }
    }
}

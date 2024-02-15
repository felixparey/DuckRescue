//
//  ContentView.swift
//  DuckRescue
//
//  Created by Felix Parey on 13/02/24.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {
    
    @Environment(AppState.self) private var appState
    @Environment(\.openImmersiveSpace) private var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) private var dismissImmersiveSpace
    
    var body: some View {
        Button("Start"){
            Task{
                appState.hittingLogic.duckHitTarget = false
                await openImmersiveSpace(id: "ImmersiveSpace")
            }
        }
        .task {
            if appState.hittingLogic.duckHitTarget{
                
                await dismissImmersiveSpace()
                
            }
           
        }
        
            
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
}

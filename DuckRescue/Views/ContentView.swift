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
    @Environment(\.dismissWindow) private var dismissWindow
    @Environment(\.openWindow) private var openWindow
    
    var body: some View {
        ZStack(alignment: .bottom){
            Image(.startUpScreen)
                .resizable()
                .aspectRatio(contentMode: .fill)
            
            Button{
                appState.startGame()
            } label: {
                if appState.readyToStart {
                    Text("Start Game")
                        .font(.title)
                        .padding()
                        .glassBackgroundEffect()
                }
                else {
                    Text("Loading...")
                        .font(.title)
                        .padding()
                }
            }
            .padding(.bottom, 40)
            .buttonStyle(.plain)
            
        }
        .onChange(of: appState.phase) { oldPhase, newPhase in
            if newPhase == .waitingToStart{
                Task{
                    await openImmersiveSpace(id: "ImmersiveSpace")
                    dismissWindow()
                    appState.windowCount = 0
                }
            }
        }
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
}

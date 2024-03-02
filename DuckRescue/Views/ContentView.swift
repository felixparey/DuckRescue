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
    
    var body: some View {
        ZStack(alignment: .bottom){
            Image(.startUpScreen)
                .resizable()
                .aspectRatio(contentMode: .fill)
            
            Button{
                Task{
                    await openImmersiveSpace(id: "ImmersiveSpace")
                    dismissWindow()
                }
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
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
}

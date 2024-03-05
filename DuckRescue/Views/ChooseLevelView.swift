//
//  ChooseLevelView.swift
//  DuckRescue
//
//  Created by Alexandr Chubutkin on 22/02/24.
//

import SwiftUI

struct ChooseLevelView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.dismissImmersiveSpace) private var dismissImmersiveSpace
    @Environment(\.openWindow) private var openWindow
    
    var body: some View {
        HStack(alignment: .center) {
            
            Button{
                
            }label: {
                Label("Select Level", systemImage: "square.grid.3x3.fill")
                    .labelStyle(.iconOnly)
            }
            .help("Select Level")
            
            Divider()
            
            Button {
                if appState.currentLevelIndex > 0 {
                    appState.currentLevelIndex -= 1
                    appState.reset()
                }
            } label: {
                Label("Previous Level", systemImage: "chevron.backward")
                    .labelStyle(.iconOnly)
            }
            .help("Previous Level")
            
            Text("Level \(appState.currentLevelIndex + 1)")
                .padding()
            
            Button {
                if appState.currentLevelIndex < appState.levels.count - 1 {
                    appState.currentLevelIndex += 1
                    appState.reset()
                }
            } label: {
                Label("Next Level", systemImage: "chevron.forward")
                    .labelStyle(.iconOnly)
            }
            .help("Next Level")
            
            Divider()
            
            Button {
                Task {
                    appState.exitGame()
                    openWindow(id: "Start")
                    appState.windowCount = 1
                    await dismissImmersiveSpace()
                }
                
            } label: {
                Label("Exit Immersive Space", systemImage: "arrow.down.right.and.arrow.up.left")
                    .labelStyle(.iconOnly)
                    
            }
            .help("Exit Game")
        }
    }
}

#Preview {
    ChooseLevelView()
}

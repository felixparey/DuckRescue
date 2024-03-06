//
//  GameOverView.swift
//  DuckRescue
//
//  Created by Felix Parey on 04/03/24.
//

import SwiftUI

struct GameOverView: View {
    
    @Environment(AppState.self) private var appState
    @Environment(\.openImmersiveSpace) private var openImmersiveSpace
    @Environment(\.dismissWindow) private var dismissWindow
    
    var body: some View {
        
        VStack{
            Text("Game Over")
                .font(.extraLargeTitle2)
            
            Button{
                appState.phase.transition(to: .waitingToStart)
                appState.reset()
            } label: {
                    Text("Try Again")
                        .font(.title)
                        .padding()
                        .glassBackgroundEffect()
            }
            .padding(.bottom, 40)
            .buttonStyle(.plain)
        }
        .onChange(of: appState.phase) { oldValue, newValue in
            if newValue == .waitingToStart{
                Task{
                    await openImmersiveSpace(id: "ImmersiveSpace")
                    dismissWindow()
                    appState.windowCount = 0
                }
            }
        }
    }
}

#Preview {
    GameOverView()
}

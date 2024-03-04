//
//  GameOverView.swift
//  DuckRescue
//
//  Created by Felix Parey on 04/03/24.
//

import SwiftUI

struct GameOverView: View {
    
    @Environment(AppState.self) private var appState
    
    var body: some View {
        
        VStack{
            Text("Game Over")
                .font(.extraLargeTitle2)
            
            Button{
                appState.phase.transition(to: .waitingToStart)
            } label: {
                    Text("Try Again")
                        .font(.title)
                        .padding()
                        .glassBackgroundEffect()
            }
            .padding(.bottom, 40)
            .buttonStyle(.plain)
        }
    }
}

#Preview {
    GameOverView()
}

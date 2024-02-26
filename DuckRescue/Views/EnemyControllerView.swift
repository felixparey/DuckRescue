//
//  EnemyControllerView.swift
//  DuckRescue
//
//  Created by Alexandr Chubutkin on 23/02/24.
//

import SwiftUI

struct EnemyControllerView: View {
    @Environment(AppState.self) private var appState
    
    var body: some View {
        VStack(spacing: 0) {
            Text("PLAY ENEMY MOVEMENT")
                .font(.title)
                .padding()
            Button {
                appState.startEnemyMoving()
            } label: {
                Label("Play", systemImage: appState.isEnemyMoving ? "pause.fill" : "play.fill")
                    .labelStyle(.iconOnly)
            }
        }
    }
}

#Preview {
    EnemyControllerView()
}

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
        HStack(alignment: .top) {
            VStack(spacing: 0) {
                Text("CHOOSE LEVEL")
                    .font(.title)
                    .padding()
                HStack(alignment: .center) {
                    Button {
                        if appState.currentLevelIndex > 0 {
                            appState.currentLevelIndex -= 1
                            appState.reset()
                        }
                    } label: {
                        Label("Back", systemImage: "chevron.backward")
                            .labelStyle(.iconOnly)
                    }
                    
                    Text("\(appState.currentLevelIndex + 1)")
                        .font(.largeTitle.bold())
                        .padding()
                        .frame(width: 100)
                    
                    Button {
                        if appState.currentLevelIndex < appState.levels.count - 1 {
                            appState.currentLevelIndex += 1
                            appState.reset()
                        }
                    } label: {
                        Label("Next", systemImage: "chevron.forward")
                            .labelStyle(.iconOnly)
                    }
                }
                
                HStack {
                    Button {
                        Task {
                            openWindow(id: "Start")
                            await dismissImmersiveSpace()
                        }
                    } label: {
                        Label("Exit", systemImage: "xmark.circle.fill")
                            .labelStyle(.titleAndIcon)
                    }
                }
                .padding()
            }
        }
    }
}

#Preview {
    ChooseLevelView()
}

//
//  StartScreen.swift
//  DuckRescue
//
//  Created by Felix Parey on 16/02/24.
//

import SwiftUI
import CloudKit

struct StartScreen: View {
    
    @Environment(AppState.self) private var appState
    @Environment(\.openImmersiveSpace) private var openImmersiveSpace
    @Environment(\.dismissWindow) private var dismissWindow
    
    var body: some View {
        ZStack(alignment: .top){
            
            VStack{
                Image(.startScreenHeader)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .offset(y: -100)
                Spacer()
            }
            VStack(spacing: 50) {
                Text("Duck Rescue")
                    .font(.extraLargeTitle2)
                    .fontWeight(.heavy)
                    .scaleEffect(2)
                    .shadow(radius: 10)
                    .padding(.top, 250)
                    .offset(z: 20)
    
                Button {
//                    Task{
//                        await openImmersiveSpace(id: "Level")
//                    }
                    Task{
                        appState.hittingLogic.duckHitTarget = false
                        await openImmersiveSpace(id: "Level")
                        dismissWindow(id: "Start")
                        appState.windowOpen = false
                    }
                    
                } label: {
                    Text("Start Game")
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                        .padding()
                        .glassBackgroundEffect()
                        
                }
                .buttonStyle(.plain)


            }
            
                
                
            
        }
//        .onAppear {
//            appState.addRecord(name: "Yuliia", yRotation: 180)
//        }
    }
}

#Preview {
    StartScreen()
}


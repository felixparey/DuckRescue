//
//  ImmersiveView.swift
//  DuckRescue
//
//  Created by Felix Parey on 13/02/24.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ImmersiveView: View {
    
    @Environment(AppState.self) private var appState
    
    var body: some View {
        
        RealityView { content in
            
            if let scene = try? await Entity(named: "YuliiaScene", in: realityKitContentBundle) {
                if let duck = try? await Entity(named: "DuckPrototypeScene", in: realityKitContentBundle){
                    
                    duck.name = "duck"
                    scene.name = "maze"
                    
                    
                    
                    duck.position.z = -1
                    duck.position.y = 1
                    
                
                    content.add(scene)
                    content.add(duck)
                    
                }
                
                
                
            }
            
        }update: { content in
            if let maze = content.entities.first?.findEntity(named: "maze"){
                let event = content.subscribe(to: CollisionEvents.Began.self, on: maze) { _ in
                    print("HITTTTTT")
                    appState.hittingLogic.duckHitTarget = true
                }
            }
        }
        .gesture(DragGesture()
            .targetedToAnyEntity()
            .onChanged { value in
                value.entity.position = value.convert(value.location3D, from: .local, to: value.entity.parent!)
            })
        
        
    }
    
   
}

#Preview {
    ImmersiveView()
        .previewLayout(.sizeThatFits)
}

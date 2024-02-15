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
    
    @State private var maze: Entity?
    @State private var duck: Entity?
    
    @State private var subscription: EventSubscription?
    
    
    
    var body: some View {
        
        RealityView { content in
            
            if let scene = try? await Entity(named: "DuckRescueScene", in: realityKitContentBundle) {
                content.add(scene)
                
                if let maze = content.entities.first?.findEntity(named: "Cube") {
                    print("found Cube")
                    self.maze = maze
                    maze.name = "maze"
                    maze.position.z = -3
                    maze.position.y = 1
                    
                } else {
                    print("couldn't find Cube")
                }
                
                if let duck = content.entities.first?.findEntity(named: "duck") {
                    print("found duck")
                    self.duck = duck
                    duck.name = "duck"
                    duck.position.z = -3
                    duck.position.y = 1
                }else {
                    print("couldn't find duck")
                }
                
                // Tracking collision of duck with other entities
                subscription = content.subscribe(to: CollisionEvents.Began.self, on: duck) { collisionEvent in
                    print("💥 Collision between \(collisionEvent.entityA.name) and \(collisionEvent.entityB.name)")
                    
                    if collisionEvent.entityB.name == "maze" {
                        appState.hittingLogic.duckHitTarget = true
                    }
                }
                
                
                
                
                
            }
            
            
            
            
        }
        // gesture for moving duck
        .gesture(
            DragGesture()
                .targetedToEntity(duck ?? Entity())
                .onChanged { value in
                    guard let duck, let parent = duck.parent else {
                        return
                    }
                    
                    duck.position = value.convert(value.location3D, from: .local, to: parent)
                }
        )
        
    }
    
    
}

#Preview {
    ImmersiveView()
        .previewLayout(.sizeThatFits)
}

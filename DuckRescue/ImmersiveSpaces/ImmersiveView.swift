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
    
    @Environment(\.openWindow) private var openWindow
    @Environment(\.dismissImmersiveSpace) private var dismissImmersiveSpace
    @Environment(AppState.self) private var appState
    
    @State private var maze: Entity?
    @State private var duck: Entity?
    
    @State private var subscription: EventSubscription?
    
    
    
    var body: some View {
        
        RealityView { content in
            
            if let scene = try? await Entity(named: "FullyImmersedScene", in: realityKitContentBundle) {
                
                
                content.add(scene)
//                content.entities.first?.position.y = 0.5
                
                
//                if let maze = content.entities.first?.findEntity(named: "Cube") {
//                    print("found Cube")
//                    self.maze = maze
//                    maze.name = "maze"
//                    maze.position.z = -0.5
//                    maze.position.y = 0.85
//                    
//                } else {
//                    print("couldn't find Cube")
//                }
                
                if let duck = content.entities.first?.findEntity(named: "duck") {
                    print("found duck")
                    self.duck = duck
                    duck.name = "duck"
//                    duck.position.z = -0.5
//                    duck.position.y = 0.85
                }else {
                    print("couldn't find duck")
                }
                
                // Tracking collision of duck with other entities
                subscription = content.subscribe(to: CollisionEvents.Began.self, on: duck) { collisionEvent in
                    print("💥 Collision between \(collisionEvent.entityA.name) and \(collisionEvent.entityB.name)")
                    
                    
                    if collisionEvent.entityB.name == "Plane"{
                        collisionEvent.entityA.components.remove(InputTargetComponent.self)
                        print("WATER HIT")
                        Task{
                            await dismissImmersiveSpace()
                        }
                        if appState.windowOpen == false{
                            openWindow(id: "Start")
                            appState.windowOpen = true
                        }
                        
                       
                        
                    }else if collisionEvent.entityB.name == "Plane_001"{
                        print("CEILING HIT")
                        
                        // Implement jump back to starting position here
                        
                        
                        
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
                    duck.position.x = value.convert(value.location3D, from: .local, to: parent).x
                    duck.position.y = value.convert(value.location3D, from: .local, to: parent).y
                }
        )
        
    }
    
    
}

#Preview {
    ImmersiveView()
        .previewLayout(.sizeThatFits)
}

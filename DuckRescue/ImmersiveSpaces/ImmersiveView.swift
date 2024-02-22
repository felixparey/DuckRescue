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
    @State private var startPoint: Entity?
    
    @State private var rat: Entity?
    @State private var spawnRat: Bool = false
    
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
                } else {
                    print("couldn't find duck")
                }
                
                if let start = content.entities.first?.findEntity(named: "carpet") {
                    print("found start Point")
                    self.startPoint = start
                    self.startPoint?.name = "startPoint"
                } else {
                    print("couldn't find start")
                }
                
                if let rat = content.entities.first?.findEntity(named: "rat") {
                    print("found rat")
                    
                    self.rat = rat
                    self.rat?.isEnabled = false
                    self.rat?.name = "rat"
                    
                    self.rat?.scale = SIMD3(x: 0.1, y: 0.2, z: 0.1)
                    
                    self.rat?.setPosition(startPoint!.position, relativeTo: nil)
                    self.rat?.position.y += 0.8
                    
                    let radians = 270.0 * Float.pi / 180.0
                    self.rat?.orientation = simd_quatf(angle: radians, axis: SIMD3(x: 0, y: 1, z: 0))
                    
                    content.add(rat)
                    
                } else {
                    print("couldn't find rat")
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
                        
                        
                        
                    } else if collisionEvent.entityB.name == "Plane_001"{
                        print("CEILING HIT")
                        
                        // Implement jump back to starting position here
                        
                        
                        
                    }
                }
                    /*
                    // spawn rat on top or starting point
                    if let rat = try? await Entity(named: "rat", in: realityKitContentBundle) {
                        print("found rat")
                        
                        self.rat = rat
                        self.rat?.name = "rat"
                        
                        self.rat?.scale = SIMD3(x: 0.1, y: 0.2, z: 0.1)
                        
                        self.rat?.setPosition(startPoint!.position, relativeTo: startPoint)
                        self.rat?.position.y += 1
                        
                       // let radians = 270.0 * Float.pi / 180.0
                       // self.rat?.orientation = simd_quatf(angle: radians, axis: SIMD3(x: 0, y: 1, z: 0))
                        
                        content.add(rat)
                        self.rat?.isEnabled = false
                    } else {
                        print("couldn't find rat")
                    }
                    */
                    

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
                    spawnRat = true
                    duck.position.x = value.convert(value.location3D, from: .local, to: parent).x
                    duck.position.y = value.convert(value.location3D, from: .local, to: parent).y
                }
        )
        .onChange(of: spawnRat) { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                print("trying to spawn rat")
                if let rat = self.rat {
                    print("enabling rat")
                    self.rat?.isEnabled = true
                }            }
            
        }
        
    }
    
    
}

#Preview {
    ImmersiveView()
        .previewLayout(.sizeThatFits)
}

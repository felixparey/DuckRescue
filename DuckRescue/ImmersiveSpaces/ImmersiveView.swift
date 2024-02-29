//
//  ImmersiveView.swift
//  DuckRescue
//
//  Created by Felix Parey on 13/02/24.
//

import SwiftUI
import RealityKit
import RealityKitContent

var enemyCurrentTubeSegmentIndex: Int = 0

struct ImmersiveView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.openWindow) private var openWindow
    @Environment(\.dismissImmersiveSpace) private var dismissImmersiveSpace
    
    
    @State private var duck: Entity?
    @State private var enemyAnimationSubscription: EventSubscription?
    @State private var duckSubscription: EventSubscription?
    
    
    var body: some View {
        RealityView { content, attachments in
            content.add(rootEntity)
            
            rootEntity.position = .init(x: 0, y: 1.3, z: -1.7)
            
            appState.reset()
            
            
            
            buildAttachments(attachments)
            
//            if let duck = content.entities.first?.findEntity(named: "duck"){
//                print("FOUND THE FUCKING DUCK")
//            }
            
            duckSubscription = content.subscribe(to: CollisionEvents.Began.self, on: nil){ event in
                
                if let duck = appState.duck{
                    
                    
                    //TODO: Make function for that
                    if appState.hittingLogic.checkColissionBetweenTrackPieces(event.entityA.name, event.entityB.name){
                        duck.setPosition([-0.8,0,0], relativeTo: levelContainer)
                        print("ONLY DUCK HIT SOMETHING")
                    }
                    
                    
                }
                print("HELLO\(event.entityA.name)")
                
                
            }
            
            enemyAnimationSubscription = content.subscribe(to: AnimationEvents.PlaybackCompleted.self, on: enemy, componentType: nil) { event in
                Task {
                    moveEnemy()
                }
            }
            
            
        } update: { updateContent, attachments in
            
            moveEnemy()
        } attachments: {
            Attachment(id: "a1") {
                ChooseLevelView()
                    .padding()
                    .glassBackgroundEffect()
            }
        }
        .gesture(DragGesture()
            .targetedToEntity(appState.duck ?? Entity())
            .onChanged { value in
                
                if let duck = appState.duck, let parent = appState.duck?.parent{
                    
                    duck.position.x = value.convert(value.location3D, from: .local, to: parent).x
                    duck.position.y = value.convert(value.location3D, from: .local, to: parent).y
                    
                }
            })
        
        /*
         .gesture(DragGesture(minimumDistance: 0.0)
         .targetedToAnyEntity()
         .onChanged { value in
         value.entity.position = value.convert(value.location3D, from: .local, to: value.entity.parent!)
         print(value)
         })
         
         .simultaneousGesture(
         TapGesture()
         .onEnded({ value in
         print(value)
         }))
         */
    }
    
    func buildAttachments(_ attachments: RealityViewAttachments) {
        if let entity = attachments.entity(for: "a1") {
            rootEntity.addChild(entity)
            entity.setPosition([1.3, -0.25, 0], relativeTo: rootEntity)
        }
    }
    
    func duckMoving(duck: Entity) {
        
        // duck.move(to: .init(translation: [2.0, 0.0, 0.0]), relativeTo: levelContainer, duration: 1.0)
        // duck.move(to: Transform(translation: [1.0, 0.0, 0.0]), relativeTo: duck.parent, duration: 5.0, timingFunction: .linear)
        
        
        
        /*
         duck.stopAllAnimations()
         
         let start = Point3D(
         x: duck.position.x,
         y: duck.position.y,
         z: duck.position.z
         )
         let end = Point3D(
         x: start.x + 2.0,
         y: start.y,
         z: start.z
         )
         let speed = 10.0
         let line = FromToByAnimation<Transform>(
         name: "line",
         from: .init(translation: simd_float3(start.vector)),
         to: .init(translation: simd_float3(end.vector)),
         duration: speed,
         bindTarget: .transform
         )
         let animation = try! AnimationResource
         .generate(with: line)
         duck.playAnimation(animation, transitionDuration: 1.0, startsPaused: false)
         */
        
    }
    
    func moveEnemy() {
        if enemyCurrentTubeSegmentIndex == appState.levels[appState.currentLevelIndex].count - 1 {
            appState.isEnemyMoving.toggle()
            return
        }
        
        if appState.isEnemyMoving {
            if let enemyAnimationPlaybackController = enemyAnimationPlaybackController,
               enemyAnimationPlaybackController.isPaused {
                enemyAnimationPlaybackController.resume()
            }
            else {
                let duration: Double = 2.0
                
                if let enemy = enemy {
                    let newPosition: SIMD3<Float> = calculateNextEnemyPosition()
                    
                    enemyAnimationPlaybackController = enemy.move(
                        to: Transform(
                            scale: SIMD3(repeating: 1.0),
                            rotation: enemy.orientation,
                            translation: newPosition),
                        relativeTo: enemy.parent,
                        duration: duration,
                        timingFunction: .linear
                    )
                }
                
                enemyCurrentTubeSegmentIndex += 1
            }
        }
        else if let enemyAnimationPlaybackController = enemyAnimationPlaybackController,
                enemyAnimationPlaybackController.isPlaying {
            enemyAnimationPlaybackController.pause()
        }
    }
    
    func calculateNextEnemyPosition() -> SIMD3<Float> {
        let currentTubeSegment = appState.levels[appState.currentLevelIndex][enemyCurrentTubeSegmentIndex]
        
        // TODO: instead calculate the next coordinates, maybe, need thinking about ready to use tube coordinates?
        var x = enemy!.position.x + tubeHeight
        var y = enemy!.position.y
        
        return .init(x: x, y: y, z: enemy!.position.z)
    }
}

#Preview {
    ImmersiveView()
        .previewLayout(.sizeThatFits)
}






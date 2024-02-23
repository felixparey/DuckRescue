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
    
    @State private var enemyAnimationSubscription: EventSubscription?
    
    var body: some View {
        RealityView { content, attachments in
            content.add(rootEntity)
            rootEntity.position  = .init(x: 0, y: 1.7, z: -1.7)
            
            appState.reset()
            
            buildAttachments(attachments)
            
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
            Attachment(id: "a2") {
                EnemyControllerView()
                    .padding()
                    .glassBackgroundEffect()
            }
        }
        .gesture(dragGesture)
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
            entity.setPosition([0.50, -0.25, 0], relativeTo: rootEntity)
        }
        if let entity = attachments.entity(for: "a2") {
            rootEntity.addChild(entity)
            entity.setPosition([0.50, -0.40, 0], relativeTo: rootEntity)
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

var dragGesture : some Gesture {
    DragGesture()
        .targetedToAnyEntity()
        .onChanged { value in
            if value.entity.name == "Rubber_Duck_01_1_geometry" {
                let y = value.entity.position.y
                value.entity.position = value.convert(value.location3D, from: .local, to: value.entity.parent!)
                value.entity.position.y = y
            }
        }
}

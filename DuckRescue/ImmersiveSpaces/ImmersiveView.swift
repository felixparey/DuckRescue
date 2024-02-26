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
        RealityView { content, attachments in
            content.add(rootEntity)
            rootEntity.position  = .init(x: 0, y: 1.7, z: -1.7)
            
            appState.reset()
            
            buildAttachments(attachments)
            
            // Recursive run move animation again after completed.
            enemyAnimationSubscription = content.subscribe(to: AnimationEvents.PlaybackCompleted.self, on: enemy, componentType: nil) { event in
                Task {
                    moveEnemy()
                }
            }
        } update: { updateContent, attachments in
            startMoveEnemy()
        } attachments: {
            Attachment(id: "a1") {
                ChooseLevelView()
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
            entity.setPosition([0.80, -0.25, 0], relativeTo: rootEntity)
        }
    }
    
    func startMoveEnemy() {
        if appState.isEnemyMoving {
            if appState.isEnemyMovingContinue {
                return
            }
            appState.isEnemyMovingContinue.toggle()
            moveEnemy()
        }
    }
    
    func moveEnemy() {
        
        if let enemyAnimationPlaybackController = enemyAnimationPlaybackController,
        enemyAnimationPlaybackController.isPaused {
            enemyAnimationPlaybackController.resume()
        }
        else {
            let duration: Double = 2.0
            if let enemy = enemy {
                if let nextPosition = calculateNextEnemyPosition() {
                    enemyAnimationPlaybackController = enemy.move(
                        to: Transform(scale: SIMD3(repeating: 1.0), rotation: enemy.orientation, translation: nextPosition),
                        relativeTo: enemy.parent,
                        duration: duration,
                        timingFunction: .linear
                    )
                    
                    enemyCurrentTubeOrderIndex += 1
                }
            }
        }
        
        /*
        if appState.isEnemyMoving {
            if let enemyAnimationPlaybackController = enemyAnimationPlaybackController,
               enemyAnimationPlaybackController.isPaused {
                enemyAnimationPlaybackController.resume()
            }
            else {
                if enemyAnimationPlaybackController == nil {
                    enemyCurrentTubeOrderIndex = 1
                }
                
                let duration: Double = 2.0
                
                if let enemy = enemy {
                    if let newPosition: SIMD3<Float> = calculateNextEnemyPosition() {
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
                }
            }
        }
        else if let enemyAnimationPlaybackController = enemyAnimationPlaybackController,
                enemyAnimationPlaybackController.isPlaying {
            enemyAnimationPlaybackController.pause()
        }
        */
    }
    
    func calculateNextEnemyPosition() -> SIMD3<Float>? {
        if let nextTube = appState.currentLevelOrderedTubes.first(where: { item in item.order == enemyCurrentTubeOrderIndex }) {
            
            // TODO: instead calculate the next coordinates, maybe, need thinking about ready to use tube coordinates?
            let x = nextTube.entity!.position.x
            let y = nextTube.entity!.position.y
            
            return .init(x: x, y: y, z: enemy!.position.z)
        }
        else {
            appState.finishEnemyMoving()
        }
        
        return nil
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

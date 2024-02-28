//
//  AppState.swift
//  DuckRescue
//
//  Created by Felix Parey on 13/02/24.
//

import Foundation
import SwiftUI
import Observation
import RealityKit
import RealityKitContent
import Combine

@Observable
public class AppState{
    //Everything concerning the logic goes here
    var hittingLogic = HittingLogic()
    
    var readyToStart = false
    var levels: [[Tube]] = []
    var currentLevelIndex = 0
    var currentLevelOrderedTubes: [(order: Int, entity: Entity?)] = []
    
    var isEnemyMoving = false
    var enemy: ModelEntity? = nil
    var enemyMoveController: AnimationPlaybackController? = nil
    var enemyMovementSubscription: Cancellable?
    var enemyCurrentSegmentOrder: Int = 1
    
    init() {
        Task { @MainActor in
            await withTaskGroup(of: Void.self) { group in
                ["straight", "corner_1", "corner_2", "corner_3", "corner_4"].forEach { name in
                    group.addTask {
                        if let model = try? await Entity(named: name, in: realityKitContentBundle) {
                            tubesModels[name] = model
                        }
                    }
                }
                
                group.addTask {
                    duck = try? await Entity(named: "Rubber_Duck_01_1.fbxEF69E24E-9C93-48F3-A001-002997AF9D6C", in: realityKitContentBundle)
                }
                
                await group.waitForAll()
            }

            await loadLevelData()
            
            self.readyToStart = true
        }
    }
    
    func reset() {
        buildLevel()
        initDuck()
        initEnemy()
    }
    
    func buildLevel() {
        levelContainer.children.removeAll()
        
        let level = levels[currentLevelIndex]
        var orderedTubes: [(order: Int, entity: Entity?)] = []
        
        for (index, tubeData) in level.enumerated() {
            let tube: Entity? = spawnTube(tubeData.name)
            if let tube = tube {
                tube.name = "\(tubeData.name)"
                tube.scale = .init(repeating: 0.08)
                
                let tubeBounds = tube.visualBounds(relativeTo: nil).max
                let horizontalDistance: Float = tubeBounds.z * 2
                let verticalDistance: Float = 0.3
                
                let i = index / 3
                let j = index % 3
                
                // let newOrientation = Rotation3D(angle: .degrees(Double(90) + Double(tubeData.rotation)), axis: .z)
                let newOrientation = Rotation3D(angle: .degrees(Double(90)), axis: .y)
                tube.orientation = simd_quatf(newOrientation)
                tube.position = [horizontalDistance * Float(j), verticalDistance * Float(i), 0.0]
                
                /*
                tube.components.set(InputTargetComponent())
                tube.components.set(HoverEffectComponent())
                */
                
                tube.generateCollisionShapes(recursive: true)
                
                levelContainer.addChild(tube)
                orderedTubes.append((order: tubeData.order, entity: tube))
            }
        }

        self.currentLevelOrderedTubes = orderedTubes.sorted(by: { a, b in a.order < b.order })
      
        rootEntity.addChild(levelContainer)
        levelContainer.setPosition([-(tubeHeight * 3 / 2), -(tubeHeight * 3 / 2), 0.0], relativeTo: rootEntity)
        
        levelContainer.addChild(debugContainer)
    }
    
    func initDuck() {
        if let duckCopy = duck?.clone(recursive: true) {
            duckCopy.name = "Duck"
            duckCopy.transform.rotation = simd_quatf(
                Rotation3D(angle: .degrees(90), axis: .y)
            )
            
            levelContainer.addChild(duckCopy)
            
            duckCopy.setPosition([0.0, -0.05, 0.0], relativeTo: levelContainer)
            duckCopy.components.set(InputTargetComponent())
            duckCopy.components.set(HoverEffectComponent())
            duckCopy.generateCollisionShapes(recursive: true)
        }
    }
    
    private func loadLevelData() async {
        if let jsonData = LevelDataJSONString.data(using: .utf8) {
            levels = JSONUtil.decode([[Tube]].self, from: jsonData)!
            print(levels)
        }
    }
}

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
                tube.scale = .init(repeating: 0.08)
                
                let tubeBounds = tube.visualBounds(relativeTo: nil).max
                let horizontalDistance: Float = tubeBounds.z * 2
                let verticalDistance: Float = 0.3
                
                let i = index / 3
                let j = index % 3
                
                // let newOrientation = Rotation3D(angle: .degrees(Double(90) + Double(tubeData.rotation)), axis: .z)
                let newOrientation = Rotation3D(angle: .degrees(Double(90)), axis: .y)
                tube.orientation = simd_quatf(newOrientation)
                
                tube.name = "tube\(tubeData.order)"
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
    
    func initEnemy() {
        self.enemy = ModelEntity(mesh: .generateSphere(radius: 0.05 / 2), materials: [SimpleMaterial(color: .yellow, isMetallic: false)])
        self.enemy?.name = "Enemy"
        levelContainer.addChild(enemy!)
    }
    
    func runEnemy() {
        if self.isEnemyMoving {
            return
        }
        
        self.isEnemyMoving.toggle()
        moveEnemy()
    }
    
    func moveEnemy() {
        let duration: Double = 0.5
        
        if let enemy = enemy {
            if let nextPosition = calculateNextEnemyPosition() {
                enemyMoveController = enemy.move(
                    to: Transform(scale: SIMD3(repeating: 1.0), rotation: enemy.orientation, translation: nextPosition),
                    relativeTo: enemy.parent,
                    duration: duration,
                    timingFunction: .linear
                )
                enemyCurrentSegmentOrder += 1
            }
            else {
                stopEnemy()
            }
        }
    }
    
    func calculateNextEnemyPosition() -> SIMD3<Float>? {
        if let nextTube = currentLevelOrderedTubes.first(where: { item in item.order == enemyCurrentSegmentOrder }) {
            let x = nextTube.entity!.position.x
            let y = nextTube.entity!.position.y
            return .init(x: x, y: y, z: enemy!.position.z)
        }
        return nil
    }
    
    func stopEnemy() {
        if self.isEnemyMoving {
            enemyMoveController?.stop()
            enemyCurrentSegmentOrder = 1
            self.isEnemyMoving.toggle()
        }
    }
    
    private func loadLevelData() async {
        if let jsonData = LevelDataJSONString.data(using: .utf8) {
            levels = JSONUtil.decode([[Tube]].self, from: jsonData)!
            print(levels)
        }
    }
}

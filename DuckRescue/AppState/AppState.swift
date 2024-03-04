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
    var duck: Entity?
    var readyToStart = false
    var duckCollisionPartner: HitTarget?
    var phase: AppPhase = .appLaunched
    
    var levels: [[Tube]] = []
    
    var currentLevelIndex = 0
    var currentLevelOrderedTubes: [(order: Int, entity: Entity?)] = []
    
    var widthOfLevel: Float = 1.2
    var startPosition: SIMD3<Float>?
    
    var isEnemyMoving = false
    var enemy: Entity? = nil
    var enemyMoveController: AnimationPlaybackController? = nil
    var enemyMovementSubscription: Cancellable?
    var enemyCurrentSegmentOrder: Int = 1
    
    var isGasMoving = false
    
    init() {
        Task { @MainActor in
            await withTaskGroup(of: Void.self) { group in
                ["Straight", "Straight-geiserEmit", "Corner1", "Corner2", "Corner3", "Corner4"].forEach { name in
                    group.addTask {
                        if let model = try? await Entity(named: name, in: realityKitContentBundle) {
                            tubesModels[name] = model
                        }
                    }
                }
                
                group.addTask {
                    self.duck = try? await Entity(named: "duckEntity", in: realityKitContentBundle)
                }
                
                group.addTask {
                    gasParticles = try? await Entity(named: "particles-gas2", in: realityKitContentBundle)
                }
                
                group.addTask {
                    startPiece = try? await Entity(named: "StartPiece", in: realityKitContentBundle)
                }
                
                group.addTask {
                    self.enemy = try? await Entity(named: "rat", in: realityKitContentBundle)
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
        //  initGasParticles()
        
    }
    
    private func buildLevel() {
        levelContainer.children.removeAll()
        
        startPiece?.scale = [0.015,0.015,0.015]
        levelContainer.addChild(startPiece!)
        startPiece?.setPosition([-0.32,-0.1,0], relativeTo: levelContainer)
        startPosition = startPiece?.position
        
        let level = levels[currentLevelIndex]
        var size: SIMD3<Float>? = nil
        
        for (index, tubeData) in level.enumerated() {
            let tube: Entity? = spawnTube(tubeData.name)
            
            if let tube = tube {
                tube.scale = .init(repeating: 0.08)
                
                if size == nil {
                    size = tube.visualBounds(relativeTo: nil).size
                }
                
                let horizontalDistance: Float = size![0]
                let verticalDistance: Float = size![1]
                
                let i = index / 5
                let j = index % 5
                
                tube.name = "tube"
                tube.position = [horizontalDistance * Float(j), verticalDistance * Float(i), 0.0]
                
                tube.generateCollisionShapes(recursive: true)
                
                levelContainer.addChild(tube)
            }
        }
        
        rootEntity.addChild(levelContainer)
        
        levelContainer.setPosition([-(tubeHeight * 5 / 2), -(tubeHeight * 5 / 2), 0.0], relativeTo: rootEntity)
    }
    
    private func initDuck() {
        if let duck = duck{
            duck.name = "Duck"
            duck.transform.rotation = simd_quatf(
                Rotation3D(angle: .degrees(90), axis: .y)
            )
            
            self.duck = duck
            startPiece?.addChild(self.duck!)
            self.duck?.components.set(HoverEffectComponent())
            self.duck?.setScale([0.8,0.8,0.8], relativeTo: levelContainer)
            self.duck?.setPosition([0.0, 2, 0.0], relativeTo: startPiece)
        }
    }
    
    private func initGasParticles() {
        levelContainer.addChild(gasParticles!)
        gasParticles?.setPosition([0.0, -0.2, 0.0], relativeTo: levelContainer)
    }
    
    private func loadLevelData() async {
        if let jsonData = LevelDataJSONString.data(using: .utf8) {
            levels = JSONUtil.decode([[Tube]].self, from: jsonData)!
            print(levels)
        }
    }
    
    public func claculateLevelWidth(){
        widthOfLevel = levelContainer.visualBounds(relativeTo: rootEntity).center.x
    }
}

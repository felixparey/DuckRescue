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
    var duck: Entity?
    var readyToStart = false
    var levels: [[Tube]] = []
    var currentLevelIndex = 0
    var widthOfLevel: Float = 1.2
    var startPosition: SIMD3<Float>?
    var isEnemyMoving = false
    var isGasMoving = false
    
    init() {
        Task { @MainActor in
            await withTaskGroup(of: Void.self) { group in
                ["STraightt", "Corner1", "Corner2", "Corner3", "Corner4"].forEach { name in
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
        
        for (index, tubeData) in level.enumerated() {
            let tube: Entity? = spawnTube(tubeData.name)

            if let tube = tube {
                tube.scale = .init(repeating: 0.08)
                
                let tubeBounds = tube.visualBounds(relativeTo: nil).max
                let horizontalDistance: Float = tubeBounds.z * 2 - 0.025
                print(tube.scale(relativeTo: nil))
                let verticalDistance: Float = 0.11430265 * 2
                
                print(tubeData.name)
                print(tubeBounds.y)
                
                let i = index / 5
                let j = index % 5
                
                // let newOrientation = Rotation3D(angle: .degrees(Double(90) + Double(tubeData.rotation)), axis: .z)
                let newOrientation = Rotation3D(angle: .degrees(Double(90)), axis: .y)
                tube.orientation = simd_quatf(newOrientation)
                
                tube.name = "tube"
                tube.position = [horizontalDistance * Float(j), verticalDistance * Float(i), 0.0]
                
                //                tube.components.set(InputTargetComponent())
                //                tube.components.set(HoverEffectComponent())
                
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
    
    private func initEnemy() {
        enemy = ModelEntity(mesh: .generateSphere(radius: 0.05 / 2), materials: [SimpleMaterial(color: .yellow, isMetallic: false)])
        levelContainer.addChild(enemy!)
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

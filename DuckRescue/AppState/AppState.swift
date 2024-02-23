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
    
    init() {
        
        Task { @MainActor in
            await loadLevelData()
            duck = try? await Entity(named: "Rubber_Duck_01_1.fbxEF69E24E-9C93-48F3-A001-002997AF9D6C", in: realityKitContentBundle)
            duck?.name = "Duck"
            self.readyToStart = true
        }
    }
    
    func reset() {
        buildLevel()
        initDuck()
    }
    
    func buildLevel() {
        levelContainer.children.removeAll()
        
        let level = levels[currentLevelIndex]
        let gap: Float = tubeHeight
        
        for (index, tubeData) in level.enumerated() {
            let tube: ModelEntity? = spawnTube(tubeData.name)
            if let tube = tube {
                let i = index / 3
                let j = index % 3
                
                let newOrientation = Rotation3D(angle: .degrees(Double(90) + Double(tubeData.rotation)), axis: .z)
                tube.name = "tube"
                tube.position = [gap * Float(j), gap * Float(i), 0.0]
                tube.orientation = simd_quatf(newOrientation)
                tube.components.set(HoverEffectComponent())
                tube.generateCollisionShapes(recursive: false)
                levelContainer.addChild(tube)
            }
        }
        
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
            duckCopy.setPosition([0.0, 0.0, 0.0], relativeTo: levelContainer)
            duckCopy.components.set(InputTargetComponent())
            duckCopy.components.set(HoverEffectComponent())
            duckCopy.generateCollisionShapes(recursive: true)
            duck = duckCopy
        }
    }
    
    private func loadLevelData() async {
        if let jsonData = LevelDataJSONString.data(using: .utf8) {
            levels = JSONUtil.decode([[Tube]].self, from: jsonData)!
            print(levels)
        }
    }
}

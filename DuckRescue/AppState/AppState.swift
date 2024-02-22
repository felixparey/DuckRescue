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
            self.readyToStart = true
        }
    }
    
    func reset() {
        buildLevel()
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
                tube.position = [gap * Float(j), gap * Float(i), 0.0]
                tube.orientation = simd_quatf(newOrientation)
                
                levelContainer.addChild(tube)
            }
        }
        
        rootEntity.addChild(levelContainer)
        levelContainer.setPosition([-(tubeHeight * 3 / 2), -(tubeHeight * 3 / 2), 0.0], relativeTo: rootEntity)
    }
    
    private func loadLevelData() async {
        if let jsonData = LevelDataJSONString.data(using: .utf8) {
            levels = JSONUtil.decode([[Tube]].self, from: jsonData)!
            print(levels)
        }
    }
}

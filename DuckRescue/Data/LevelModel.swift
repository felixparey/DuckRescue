//
//  LevelModel.swift
//  DuckRescue
//
//  Created by Felix Parey on 19/02/24.
//

import Foundation
import SwiftData
import RealityKit
import CloudKit




@Observable
class LevelSegment{
    
    var entityName: String
    var yRotation: Float
    var position: SIMD3<Float>
    
    init(entityName: String, yRotation: Float, position: SIMD3<Float>) {
        self.entityName = entityName
        self.yRotation = yRotation
        self.position = position
    }
}


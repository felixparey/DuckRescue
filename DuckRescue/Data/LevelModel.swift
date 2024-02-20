//
//  LevelModel.swift
//  DuckRescue
//
//  Created by Felix Parey on 19/02/24.
//

import Foundation
import SwiftData
import RealityKit

//@Model
//class Level{
//    
//    var segments: [LevelSegment]
//    
//    init(segments: [LevelSegment]) {
//        self.segments = segments
//    }
//    
//}

@Observable
class LevelSegment{
    
    var entity: Entity
    var yRotation: Float?
    var position: SIMD3<Float>
    
    init(entity: Entity, yRotation: Float? = nil, position: SIMD3<Float>) {
        self.entity = entity
        self.yRotation = yRotation
        self.position = position
    }
    
}


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

struct DataEntity: Codable{
    
   
}


@Observable
class LevelSegment{
    
    var entity: Entity
    var yRotation: Float
    var position: SIMD3<Float>
    
    init(entity: Entity, yRotation: Float, position: SIMD3<Float>) {
        self.entity = entity
        self.yRotation = yRotation
        self.position = position
    }
    
    let record = CKRecord(recordType: "DataEntity")
    
    
}


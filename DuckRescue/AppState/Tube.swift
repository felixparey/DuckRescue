//
//  Tube.swift
//  DuckRescue
//
//  Created by Alexandr Chubutkin on 22/02/24.
//

import Foundation
import RealityKit

struct Tube : Decodable {
    var name: String
    var rotation: Float
    
    init(name: String, rotation: Float) {
        self.name = name
        self.rotation = rotation
    }
}

let tubeRadius: Float = 0.05
let tubeHeight: Float = 0.25

let redTubeMaterial = {
    var material = SimpleMaterial(color: .red.withAlphaComponent(0.5), isMetallic: false)
    material.roughness = 0.90
    return material
}()
let greenTubeMaterial = {
    var material = SimpleMaterial(color: .green.withAlphaComponent(0.5), isMetallic: false)
    material.roughness = 0.90
    return material
}()

func spawnTube(_ name: String) -> ModelEntity? {
    let tube: ModelEntity?
    
    switch name {
    case "RedTube":
        tube = ModelEntity(mesh: .generateCylinder(height: tubeHeight, radius: tubeRadius), materials: [redTubeMaterial])
    case "GreenTube":
        tube = ModelEntity(mesh: .generateCylinder(height: tubeHeight, radius: tubeRadius), materials: [greenTubeMaterial])
    default:
        tube = nil
    }
    
    return tube
}


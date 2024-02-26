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
    var order: Int
    
    init(name: String, rotation: Float, order: Int) {
        self.name = name
        self.rotation = rotation
        self.order = order
    }
}

let tubeRadius: Float = 0.05
let tubeHeight: Float = 0.25
var tubesModels: [String: Entity?] = [:]

let redTubeMaterial = {
    var material = SimpleMaterial(color: .red.withAlphaComponent(0.8), isMetallic: false)
    material.roughness = 0.90
    return material
}()
let greenTubeMaterial = {
    var material = SimpleMaterial(color: .green.withAlphaComponent(0.8), isMetallic: false)
    material.roughness = 0.90
    return material
}()

func spawnTube(_ name: String) -> Entity? {
    return tubesModels[name]??.clone(recursive: true)
}


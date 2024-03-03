//
//  EnemyMovementSystem.swift
//  DuckRescue
//
//  Created by Alexandr Chubutkin on 27/02/24.
//

import Foundation
import RealityKit

class EnemyMovementComponent : Component {
    
}

class EnemyMovementSystem : System {
    private static let query = EntityQuery(where: .has(EnemyMovementComponent.self))
    
    required init(scene: Scene) {
        
    }

    func update(context: SceneUpdateContext) {
        let velocity = 1.0
        let deltaTime = context.deltaTime
        
        if let enemy = context.scene.findEntity(named: "Enemy") {
            // enemy.setPosition([enemy.position.x + Float(velocity * deltaTime), 0.0, 0.0], relativeTo: enemy.parent)
        }
    }
}


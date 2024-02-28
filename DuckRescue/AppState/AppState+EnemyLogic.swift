//
//  AppState+EnemyLogic.swift
//  DuckRescue
//
//  Created by Alexandr Chubutkin on 28/02/24.
//

import Foundation
import RealityKit
import RealityKitContent

extension AppState {
    func initEnemy() {
        self.enemy = ModelEntity(mesh: .generateSphere(radius: 0.05 / 2), materials: [SimpleMaterial(color: .yellow, isMetallic: false)])
        self.enemy?.name = "Enemy"
        levelContainer.addChild(enemy!)
    }
    
    func runEnemy() {
        if self.isEnemyMoving {
            return
        }
        
        self.isEnemyMoving.toggle()
        
        // Recursive run move animation again after completed.
        if enemyMovementSubscription != nil {
            enemyMovementSubscription?.cancel()
        }
        
        enemyMovementSubscription = rootEntity.scene!.subscribe(to: AnimationEvents.PlaybackCompleted.self, on: enemy, componentType: nil) { event in
            self.moveEnemy()
        }
        
        moveEnemy()
    }
    
    func moveEnemy() {
        let duration: Double = 1
        
        if let enemy = enemy {
            if let nextPosition = calculateNextEnemyPosition() {
                let goStraight = FromToByAnimation<Transform>(
                    name: "goStraight",
                    from: .init(translation: enemy.position),
                    to: .init(translation: nextPosition),
                    duration: duration,
                    bindTarget: .transform
                )
                
                let goStraightAnimation = try! AnimationResource
                    .generate(with: goStraight)
                
                enemyMoveController = enemy.playAnimation(goStraightAnimation)
                
                enemyCurrentSegmentOrder += 1
            }
            else {
                stopEnemy()
            }
        }
    }
    
    func calculateNextEnemyPosition() -> SIMD3<Float>? {
        if let nextTube = currentLevelOrderedTubes.first(where: { item in item.order == enemyCurrentSegmentOrder }) {
            let x = nextTube.entity!.position.x
            let y = nextTube.entity!.position.y
            return .init(x: x, y: y, z: enemy!.position.z)
        }
        return nil
    }
    
    func stopEnemy() {
        if self.isEnemyMoving {
            enemyMoveController?.stop()
            enemyCurrentSegmentOrder = 1
            self.enemy?.setPosition([0, 0, 0], relativeTo: self.enemy?.parent)
            self.isEnemyMoving.toggle()
        }
    }
}

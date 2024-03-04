//
//  AppState+EnemyLogic.swift
//  DuckRescue
//
//  Created by Alexandr Chubutkin on 28/02/24.
//

import Foundation
import RealityKit
import RealityKitContent

let DuckDistanceXToStartEnemyMovement: Float = 32

extension AppState {
    func initEnemy() {
        if let position = startPiece?.position {
            enemy!.setPosition([position.x, 0.0, position.z], relativeTo: enemy!.parent)
        }
        
        enemyAnimations = buildEnemyMovementAnimation()
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
        
        // TODO: call to enemy spawn sound/particles effects here
        
        enemy!.name = "Enemy"
        levelContainer.addChild(enemy!)
        
        moveEnemy()
    }
    
    func moveEnemy() {
        guard let enemy = enemy else {
            return
        }
        
        if let animations = self.enemyAnimations {
            enemyMoveController = enemy.playAnimation(animations)
        }
        else {
            stopEnemy()
        }
    }
    
    private func buildEnemyMovementAnimation() -> AnimationResource? {
        let duration: Double = 40
        var transforms: [Transform] = [Transform(translation: enemy!.position)]
        
        for i in 0..<currentLevelOrderedTubes.count {
            let currentEntity = currentLevelOrderedTubes[i].entity!
            let nextEntity = (i + 1 < currentLevelOrderedTubes.count) ? currentLevelOrderedTubes[i + 1].entity! : nil
            let prevEntity = (i - 1 >= 0) ? currentLevelOrderedTubes[i - 1].entity! : nil
            
            if currentEntity.name.hasPrefix("Straight") {
                transforms.append(.init(translation: [currentEntity.position.x, currentEntity.position.y, currentEntity.position.z]))
            } else if currentEntity.name.hasPrefix("Corner") {
                let points = calculateSmoothTrajectoryv2(prevEntity, currentEntity, nextEntity)
                points.forEach { point in
                    transforms.append(point)
                }
            }
        }
        
        let animation = SampledAnimation(frames: transforms, frameInterval: Float(duration) / Float(transforms.count), bindTarget: .transform, delay: 0)
        let animationResource = try! AnimationResource
            .generate(with: animation)
        return animationResource
    }
    
    func calculateSmoothTrajectoryv2(_ entity0: Entity?, _ entity1: Entity?, _ entity2: Entity?) -> [Transform] {
        guard let entity0 = entity0, let entity1 = entity1, let entity2 = entity2 else {
            return []
        }
        
        // TODO: don't do it constants like this, never
        let _0point32: Float = 0.32 / 2
        let _0point16: Float = 0.16 / 2
        
        var controlPoints: [SIMD3<Float>] = []
        
        switch entity1.name {
        case "Corner1":
            controlPoints = [
                entity1.position + [-(_0point32), 0.0, 0.0],
                entity1.position + [-(_0point16), 0.0, 0.0],
                entity1.position + [-(_0point16), _0point16, 0.0]
            ]
        case "Corner2":
            controlPoints = [
                entity1.position + [-(_0point16), -(_0point16), 0.0],
                entity1.position + [-(_0point16), 0.0, 0.0],
                entity1.position + [-(_0point32), 0.0, 0.0]
            ]
        case "Corner3":
            controlPoints = [
                entity1.position + [_0point16, -(_0point16), 0.0],
                entity1.position + [_0point16, 0.0, 0.0],
                entity1.position + [_0point32, 0.0, 0.0]
            ]
        case "Corner4":
            controlPoints = [
                entity1.position + [_0point32, 0.0, 0.0],
                entity1.position + [_0point16, 0.0, 0.0],
                entity1.position + [_0point16, _0point16, 0.0]
            ]
        default:
            break
        }
        
        // TODO: next, all okay
        // Sample points along the trajectory
        let numSamples = 8
        var sampledTransforms: [Transform] = []
        for i in 0..<numSamples {
            let t = Float(i) / Float(numSamples - 1)
            let point = getQuadraticBezierPoint(start: controlPoints[0], control: controlPoints[1], end: controlPoints[2], t: t)
            let transform = Transform(scale: SIMD3<Float>(repeating: 1.0), rotation: simd_quatf(), translation: point)
            sampledTransforms.append(transform)
        }
        
        return sampledTransforms
    }
    
    func stopEnemy() {
        if self.isEnemyMoving {
            enemyMoveController?.stop()
            enemyCurrentSegmentOrder = 1
            self.enemy?.setPosition([0, 0, 0], relativeTo: self.enemy?.parent)
            self.isEnemyMoving.toggle()
        }
    }
    
    private func getQuadraticBezierPoint(start: simd_float3, control: simd_float3, end: simd_float3, t: Float) -> simd_float3 {
        let t2 = t * t
        let a = (2 * t - 2 * t2)
        let b = (t2 - 2 * t + 1)
        let res = t2 * end + a * control + b * start
        return res
    }
}

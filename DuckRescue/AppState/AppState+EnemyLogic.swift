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
        // Wrap enemy model into entity to reset incorrect rotation in original model
        // and simplify manage it's position/rotation etc.
        let originalEnemyModel = self.enemy!
        
        let wrapper = Entity()
        wrapper.name = "Enemy"
        wrapper.addChild(originalEnemyModel)
        
        originalEnemyModel.setOrientation(simd_quatf(.init(angle: .degrees(-90), axis: .y)), relativeTo: originalEnemyModel.parent)
        
        self.enemy = wrapper
        
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
        guard let enemy = enemy else {
            return
        }
        
        if let moveAnimation = calculateMovementAnimation() {
            enemyMoveController = enemy.playAnimation(moveAnimation)
            enemyCurrentSegmentOrder += 1
        }
        else {
            stopEnemy()
        }
    }
    
    func calculateMovementAnimation() -> AnimationResource? {
        guard let enemy = enemy else {
            return nil
        }
        
        guard let nextTube = currentLevelOrderedTubes.first(where: { item in item.order == enemyCurrentSegmentOrder }) else {
            return nil
        }

        let nextPosition: SIMD3<Float> = .init(x: nextTube.entity!.position.x, y: nextTube.entity!.position.y, z: enemy.position.z)
        let duration: Double = 1
        let segmentEntityName = nextTube.entity?.name
        let distanceBetweenSegmentsX: Float = 0.40701035 // TODO: hardcoded distance because without strong grid size
        let halfOfDistance = distanceBetweenSegmentsX / 2
        
        switch segmentEntityName {
        case "corner_1":
            let go = FromToByAnimation<Transform>(
                from: .init(translation: enemy.position),
                to: .init(translation: nextPosition - [halfOfDistance, 0.0, 0.0]),
                duration: duration,
                bindTarget: .transform
            )
            let start = go.toValue!.translation
            let control: simd_float3 = nextPosition
            let end = nextPosition + [0.0, halfOfDistance, 0.0]
            let step = 0.02
            var transforms: [Transform] = []
            for i in stride(from: 0.0, to: 1.0, by: step) {
                transforms.append(Transform(translation: getQuadraticBezierPoint(start: start, control: control, end: end, t: Float(i))))
            }
            let turn = SampledAnimation(frames: transforms, frameInterval: Float(duration) / Float(transforms.count), bindTarget: .transform, delay: duration)
            
            let group = AnimationGroup(group: [go, turn])
            let groupAnimation = try! AnimationResource
                .generate(with: group)
            
            return groupAnimation
        case "corner_2":
            let start = enemy.position
            let control: simd_float3 = nextPosition
            let end = nextPosition - [halfOfDistance, 0.0, 0.0]
            let step = 0.02
            var transforms: [Transform] = []
            for i in stride(from: 0.0, to: 1.0, by: step) {
                transforms.append(Transform(translation: getQuadraticBezierPoint(start: start, control: control, end: end, t: Float(i))))
            }
            let turn = SampledAnimation(frames: transforms, frameInterval: Float(duration) / Float(transforms.count), bindTarget: .transform)
            let go = FromToByAnimation<Transform>(
                from: .init(translation: end),
                to: .init(translation: nextPosition - [halfOfDistance, 0.0, 0.0]),
                duration: duration,
                bindTarget: .transform,
                delay: duration
            )
            
            let group = AnimationGroup(group: [turn, go])
            let groupAnimation = try! AnimationResource
                .generate(with: group)
            
            return groupAnimation
        case "corner_3":
            let start = enemy.position
            let control: simd_float3 = nextPosition
            let end = nextPosition + [halfOfDistance, 0.0, 0.0]
            let step = 0.02
            var transforms: [Transform] = []
            for i in stride(from: 0.0, to: 1.0, by: step) {
                transforms.append(Transform(translation: getQuadraticBezierPoint(start: start, control: control, end: end, t: Float(i))))
            }
            let turn = SampledAnimation(frames: transforms, frameInterval: Float(duration) / Float(transforms.count), bindTarget: .transform)
            let go = FromToByAnimation<Transform>(
                from: .init(translation: end),
                to: .init(translation: nextPosition + [halfOfDistance, 0.0, 0.0]),
                duration: duration,
                bindTarget: .transform,
                delay: duration
            )
            
            let group = AnimationGroup(group: [turn, go])
            let groupAnimation = try! AnimationResource
                .generate(with: group)
            
            return groupAnimation
        case "corner_4":
            let go = FromToByAnimation<Transform>(
                from: .init(translation: enemy.position),
                to: .init(translation: nextPosition + [halfOfDistance, 0.0, 0.0]),
                duration: duration,
                bindTarget: .transform
            )
            let start = go.toValue!.translation
            let control: simd_float3 = nextPosition
            let end = nextPosition + [0.0, halfOfDistance, 0.0]
            let step = 0.02
            var transforms: [Transform] = []
            for i in stride(from: 0.0, to: 1.0, by: step) {
                transforms.append(Transform(translation: getQuadraticBezierPoint(start: start, control: control, end: end, t: Float(i))))
            }
            let turn = SampledAnimation(frames: transforms, frameInterval: Float(duration) / Float(transforms.count), bindTarget: .transform, delay: duration)
            
            let group = AnimationGroup(group: [go, turn])
            let groupAnimation = try! AnimationResource
                .generate(with: group)
            
            return groupAnimation
        default:
            let go = FromToByAnimation<Transform>(
                from: .init(translation: enemy.position),
                to: .init(translation: nextPosition),
                duration: duration,
                bindTarget: .transform
            )
            
            let goStraightAnimation = try! AnimationResource
                .generate(with: go)
            
            return goStraightAnimation
        }
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

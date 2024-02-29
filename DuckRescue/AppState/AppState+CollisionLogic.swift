//
//  AppState+CollisionLogic.swift
//  DuckRescue
//
//  Created by Felix Parey on 13/02/24.
//

import Foundation
import RealityKit


extension AppState{
    
    @Observable
    public class HittingLogic{
        
        var duckHitTarget = false
        
        func resetDuck(_ duck: Entity, _ startPosition: SIMD3<Float>){
            duck.components.remove(InputTargetComponent.self)
            duck.move(to: Transform(translation: startPosition), relativeTo: duck.parent, duration: 2, timingFunction: .easeInOut)
        }
    }
    
    //    public func duckHitTarget() -> Bool{
    //
    //        return true
    //
    //    }
    
}

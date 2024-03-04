//
//  AppState+CollisionLogic.swift
//  DuckRescue
//
//  Created by Felix Parey on 13/02/24.
//

import Foundation
import RealityKit


extension AppState{
    
    enum HitTarget{
        case Floor
        case Ceiling
        case Geysir
        case Rat
        case Start
        case End
        case Nothing
    }
        
    func setDuckCollisonPartner(_ entityA: Entity, _ entityB: Entity){
        
        if entityA.name == "duck"{
            switch entityB.name{
            case "Plane_001": duckCollisionPartner = .Floor
            case "Ceiling": duckCollisionPartner = .Ceiling
            case "Geysir": duckCollisionPartner = .Geysir
            case "Rat": duckCollisionPartner = .Rat
            case "Start": duckCollisionPartner = .Start
            case "End": duckCollisionPartner = .End
            default: duckCollisionPartner = .Nothing
            }
            
            self.phase.transition(to: .hitSomething)
            
        }else if entityB.name == "duck"{
            switch entityA.name{
            case "Floor": duckCollisionPartner = .Floor
            case "Ceiling": duckCollisionPartner = .Ceiling
            case "Geysir": duckCollisionPartner = .Geysir
            case "Rat": duckCollisionPartner = .Rat
            case "Start": duckCollisionPartner = .Start
            case "End": duckCollisionPartner = .End
            default: duckCollisionPartner = .Nothing
            }
            
            self.phase.transition(to: .hitSomething)
            
        }
        
        
    }
    
    func checkIfCollisionIsWorking(){
        switch duckCollisionPartner{
        case .Floor: print("Duck hit the Floor")
        case .Ceiling: print("Duck hit the Ceiling")
        case .End: print("Duck finished Level")
        default: print("Hit Nothing Yet")
        }
    }

}

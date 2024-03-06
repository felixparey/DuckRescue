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
            let array = ["Floor1", "Floor2", "Floor3"]
            switch entityB.name{
            case "Plane_001", "Floor1", "Floor2", "Floor3", "Floor4", "Floor5", "Floor6", "Floor7", "Floor8", "Floor9", "Floor10": duckCollisionPartner = .Floor
            case "Ceiling": duckCollisionPartner = .Ceiling
            case "Geysir": duckCollisionPartner = .Geysir
            case "Sphere": duckCollisionPartner = .Rat
            case "earth_realistc_lod0": 
                duckCollisionPartner = .End
                ImmersiveView.isGestureLock = true
            default: duckCollisionPartner = .Nothing
            }
            
        }else if entityB.name == "duck"{
            switch entityA.name{
            case "Floor": duckCollisionPartner = .Floor
            case "Ceiling": duckCollisionPartner = .Ceiling
            case "Geysir": duckCollisionPartner = .Geysir
            case "Sphere": duckCollisionPartner = .Rat
            case "earth_realistc_lod0": 
                duckCollisionPartner = .End
                ImmersiveView.isGestureLock = true
            default: duckCollisionPartner = .Nothing
            }
            
        }
        
        
    }
    
    func checkIfCollisionIsWorking(){
        switch duckCollisionPartner{
        case .Floor, .Ceiling, .Geysir, .Rat: gameOver()
        case .End: 
            goToNextLevel()
        default: return
        }
    }

}

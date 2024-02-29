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
        
        func checkColissionBetweenTrackPieces(_ entityA: String, _ entityB: String) -> Bool{
            
            let straightPiece = "_untitled_Geom__StraightWithFixedOrigin_Geom_Cube"
            let curvePiece = "_corner_1_Geom__Scene_Geom__CurveWithFixedOrigin_Geom_Pipe"
            
            if entityA == straightPiece && entityB == straightPiece{
                return false
            }else if entityA == straightPiece && entityB == curvePiece{
                return false
            }else if entityA == curvePiece && entityB == straightPiece{
                return false
            }else if entityA == curvePiece && entityB == curvePiece{
                return false
            }else{
                return true
            }
        }
    }
    
    //    public func duckHitTarget() -> Bool{
    //
    //        return true
    //
    //    }
    
}

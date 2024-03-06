//
//  AppState+Phases.swift
//  DuckRescue
//
//  Created by Felix Parey on 04/03/24.
//

import Foundation
import RealityKit

extension AppState{
    public func startGame(){
        phase.transition(to: .waitingToStart)
    }
    
    public func exitGame(){
        phase.transition(to: .exitingGame)
    }
    
    public func gameOver(){
        phase.transition(to: .hitSomething)
    }
    
    public func goToNextLevel(){
        phase.transition(to: .levelBeaten)
        currentLevelIndex += 1
        reset()
        phase.transition(to: .waitingToStart)
    }
}

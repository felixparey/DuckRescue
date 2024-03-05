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
        self.reset()
    }
    
    public func exitGame(){
        phase.transition(to: .exitingGame)
    }
    
    public func gameOver(){
        //TODO: handle logic of disabling everything besides Game Over Window
        phase.transition(to: .hitSomething)
        
    }
    
    public func goToNextLevel(){
        phase.transition(to: .levelBeaten)
        currentLevelIndex += 1
        duck?.components.removeAll()
        reset()
        print("Current Giovanni\(currentLevelIndex)")
        phase.transition(to: .waitingToStart)
    }
    
}

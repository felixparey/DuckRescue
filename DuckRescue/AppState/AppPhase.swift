//
//  AppPhase.swift
//  DuckRescue
//
//  Created by Felix Parey on 04/03/24.
//

import Foundation

public enum AppPhase{
    
    case appLaunched
    case waitingToStart
    case levelRunning
    case hitSomething
    case levelBeaten
    case exitingGame
    
    
    public mutating func transition(to newPhase: AppPhase){
        if !(self == newPhase){
            self = newPhase
        }
    }
}

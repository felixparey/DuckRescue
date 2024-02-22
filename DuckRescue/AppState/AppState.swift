//
//  AppState.swift
//  DuckRescue
//
//  Created by Felix Parey on 13/02/24.
//

import Foundation
import SwiftUI
import Observation

@Observable
public class AppState{
    //Everything concerning the logic goes here
    var hittingLogic = HittingLogic()
    
    var readyToStart = false
    var levels: [[Tube]] = []
    
    init() {
        Task { @MainActor in
            self.readyToStart = true
        }
    }
}

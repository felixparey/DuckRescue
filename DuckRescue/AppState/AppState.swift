//
//  AppState.swift
//  DuckRescue
//
//  Created by Felix Parey on 13/02/24.
//

import Foundation
import SwiftUI
import Observation
import CloudKit

@Observable
public class AppState{
    
    var hittingLogic = HittingLogic()
    
    let publicDatabase = CKContainer(identifier: "iCloud.com.felixparey.duckrescue.levels").publicCloudDatabase
    let record = CKRecord(recordType: "EntityData")
    
    var windowOpen = true
}

//
//  AppState+CloudKit.swift
//  DuckRescue
//
//  Created by Felix Parey on 22/02/24.
//

import Foundation
import CloudKit

extension AppState{
    
    public func addRecord(name: String, yRotation: Float){
        
        record["name"] = name as CKRecordValue
        record["yRotation"] = yRotation as CKRecordValue
        
        publicDatabase.save(record) { record, error in
            if let error = error{
                print("Houston, we have a problem")
            }else{
                print("Record successfully saved")
            }
        }
        
    }
}

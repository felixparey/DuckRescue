//
//  Utils.swift
//  DuckRescue
//
//  Created by Alexandr Chubutkin on 21/02/24.
//

import Foundation

class JSONUtil {
    
    // Encode an object to JSON
    static func encode<T: Encodable>(_ object: T) -> Data? {
        let encoder = JSONEncoder()
        do {
            let jsonData = try encoder.encode(object)
            return jsonData
        } catch {
            print("Error encoding object to JSON: \(error.localizedDescription)")
            return nil
        }
    }
    
    // Decode JSON to an object
    static func decode<T: Decodable>(_ type: T.Type, from jsonData: Data) -> T? {
        let decoder = JSONDecoder()
        do {
            let decodedObject = try decoder.decode(type, from: jsonData)
            return decodedObject
        } catch {
            print("Error decoding JSON to object: \(error.localizedDescription)")
            return nil
        }
    }
}

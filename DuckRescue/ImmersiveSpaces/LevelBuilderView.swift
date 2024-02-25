//
//  LevelBuilderView.swift
//  DuckRescue
//
//  Created by Felix Parey on 19/02/24.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct LevelBuilderView: View {
    
    @State private var levelSegments: [LevelSegment] = []
    @State private var entityToBeAdded: Entity?
    @State private var rootEntity = Entity()
    
    var body: some View {
        
        RealityView(){ content in
            print("reality View Openend")
            let color: [UIColor] = [.red, .green, .yellow, .magenta]
            let mesh = MeshResource.generateBox(size: 0.2)
            let material = SimpleMaterial(color: .red, isMetallic: true)
            let modelEntity = ModelEntity(mesh: mesh, materials: [material])
            
            let modelEntityArray: [ModelEntity] = [ModelEntity(mesh: mesh, materials: [SimpleMaterial(color: .blue, isMetallic: false)]), modelEntity, ModelEntity(mesh: mesh, materials: [SimpleMaterial(color: .green, isMetallic: false)]) ]
            content.add(rootEntity)
            
            for i in 0..<15{
                
                var xPos: Float
                var yPos: Float
                let floatI = Float(i)
                
                switch i {
                    
                case 0,1,2,3,4:
                    
                    xPos = Float(i)*4
                    print("GIOBANNI\(floatI)")
                    yPos = 1
                    
                case 5,6,7,8,9:
                    xPos = Float(i)*4
                    yPos = 3
                    
                case 10,11,12,13,14:
                    xPos = Float(i)*4 
                    yPos = 5
                    
                default:
                    xPos = 0
                    yPos = 0
                }
                
                levelSegments.append(LevelSegment(entityName: "RatStraightAnimation", yRotation: 90, position: [xPos,yPos,-2]))
            }
            if let firstEntityName = levelSegments.first?.entityName {
                
                print("count of entities in array: \(levelSegments.count)")
                
                levelSegments.forEach { segment in
                    Task{
                        entityToBeAdded = try? await Entity(named: segment.entityName, in: realityKitContentBundle)
                        entityToBeAdded?.position = segment.position
                        entityToBeAdded?.transform.rotation = simd_quatf(Rotation3D(angle: .degrees(Double(segment.yRotation)), axis: .y))
                        rootEntity.addChild(entityToBeAdded!)
                    }
                       
                        
                        
                        
                        print(segment.position.x)
                    
 
                }
                
                
//                levelSegments[2].entity.position = levelSegments[2].position
//                print(levelSegments[2].position)
//                levelSegments[6].entity.position = levelSegments[6].position
//                levelSegments[11].entity.position = levelSegments[11].position
//                content.add(levelSegments[2].entity)
//                content.add(levelSegments[6].entity)
//                content.add(levelSegments[11].entity)
                print(content.entities.count)
                print(levelSegments.compactMap({$0.position}))
            }
            
            
            
            
        }
    }
}

#Preview(windowStyle: .volumetric) {
    LevelBuilderView()
}


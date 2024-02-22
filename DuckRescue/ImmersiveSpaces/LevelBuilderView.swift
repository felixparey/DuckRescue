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
    
    var body: some View {
        
        RealityView(){ content in
            print("reality View Openend")
            let color: [UIColor] = [.red, .green, .yellow, .magenta]
            let mesh = MeshResource.generateBox(size: 0.2)
            let material = SimpleMaterial(color: .red, isMetallic: true)
            let modelEntity = ModelEntity(mesh: mesh, materials: [material])
            
            let modelEntityArray: [ModelEntity] = [ModelEntity(mesh: mesh, materials: [SimpleMaterial(color: .blue, isMetallic: false)]), modelEntity, ModelEntity(mesh: mesh, materials: [SimpleMaterial(color: .green, isMetallic: false)]) ]
            
            
            for i in 0..<16{
                
                var xPos: Float
                var yPos: Float
                let floatI = Float(i)
                
                switch i {
                    
                case 0,1,2,3,4:
                    
                    xPos = Float(i)/5
                    print("GIOBANNI\(floatI)")
                    yPos = 0
                    
                case 5,6,7,8,9:
                    xPos = Float(i)/5 - 1
                    yPos = 0.2
                    
                case 10,11,12,13,14:
                    xPos = Float(i)/5 - 2
                    yPos = 0.4
                    
                default:
                    xPos = 0
                    yPos = 0
                }
                
                try? await levelSegments.append(LevelSegment(entity: Entity(named: "duck1", in: realityKitContentBundle), yRotation: 90, position: [xPos, yPos, 0]))
            }
            if let firstEntity = levelSegments.first?.entity {
                
                print("count of entities in array: \(levelSegments.count)")
                
                levelSegments.forEach { segment in
                    
                    segment.entity.position = segment.position
                    
                    segment.entity.position.y = segment.position.y
                    segment.entity.position.x = segment.position.x
                    segment.entity.position.z = -2
                    print(segment.position.x)
                    content.add(segment.entity)

                    
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


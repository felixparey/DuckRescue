//
//  ImmersiveView.swift
//  DuckRescue
//
//  Created by Felix Parey on 13/02/24.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ImmersiveView: View {
    
    @Environment(AppState.self) private var appState
    
    private let tubeRadius: Float = 0.05
    private let tubeHeight: Float = 0.25
    
    private let redTubeMaterial = {
        var material = SimpleMaterial(color: .red, isMetallic: false)
        material.roughness = 0.90
        return material
    }()
    private let greenTubeMaterial = {
        var material = SimpleMaterial(color: .green, isMetallic: false)
        material.roughness = 0.90
        return material
    }()
    
    private let levelTubeDataItems: [Tube] = [
        Tube(name: "RedTube", rotation: 0),
        Tube(name: "RedTube", rotation: 0),
        Tube(name: "GreenTube", rotation: 90),
        
        Tube(name: "GreenTube", rotation: 90),
        Tube(name: "RedTube", rotation: 0),
        Tube(name: "GreenTube", rotation: 90),
        
        Tube(name: "GreenTube", rotation: 90),
        Tube(name: "RedTube", rotation: 0),
        Tube(name: "RedTube", rotation: 0)
    ]
    
    var body: some View {
        RealityView { content in
            content.add(rootEntity)
            rootEntity.position  = .init(x: 0, y: 1.7, z: -1.7)
            
            await loadData()
            buildLevel()
        } update: { content in
            
        }
        .gesture(DragGesture(minimumDistance: 0.0)
            .targetedToAnyEntity()
            .onChanged { value in
                value.entity.position = value.convert(value.location3D, from: .local, to: value.entity.parent!)
                
                print(value)
            })
        .simultaneousGesture(
            TapGesture()
                .onEnded({ value in
                    print(value)
                }))
    }
    
    func loadData() async {
        
    }
    
    func buildLevel() {
        let gap: Float = tubeHeight
        
        for (index, tubeData) in levelTubeDataItems.enumerated() {
            let tube: ModelEntity?
            
            switch tubeData.name {
            case "RedTube":
                tube = ModelEntity(mesh: .generateCylinder(height: tubeHeight, radius: tubeRadius), materials: [redTubeMaterial])
            case "GreenTube":
                tube = ModelEntity(mesh: .generateCylinder(height: tubeHeight, radius: tubeRadius), materials: [greenTubeMaterial])
            default:
                tube = nil
            }
            
            if let tube = tube {
                let i = index / 3
                let j = index % 3
                
                let newOrientation = Rotation3D(angle: .degrees(Double(90) + Double(tubeData.rotation)), axis: .z)
                tube.position = [gap * Float(j), gap * Float(i), 0.0]
                tube.orientation = simd_quatf(newOrientation)
                
                levelContainer.addChild(tube)
            }
        }
        
        rootEntity.addChild(levelContainer)
        levelContainer.setPosition([-(tubeHeight * 3 / 2), -(tubeHeight * 3 / 2), 0.0], relativeTo: rootEntity)
    }
}

#Preview {
    ImmersiveView()
        .previewLayout(.sizeThatFits)
}

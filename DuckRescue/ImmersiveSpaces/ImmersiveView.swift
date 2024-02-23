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
    
    var body: some View {
        RealityView {  content, attachments in
            content.add(rootEntity)
            rootEntity.position  = .init(x: 0, y: 1.7, z: -1.7)
            
            appState.reset()
            buildAttachments(attachments)
        } update: { updateContent, attachments in
            if appState.readyToStart {
                if let duck = duck {
                    duckMoving(duck: duck)
                }
            }
        } attachments: {
            Attachment(id: "a1") {
                ChooseLevelView()
            }
        }
        .gesture(DragGesture(minimumDistance: 0.0)
            .targetedToEntity(duck!)
            .onChanged { value in
                print(value)
            }
        )
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
    
    func buildAttachments(_ attachments: RealityViewAttachments) {
        if let entity = attachments.entity(for: "a1") {
            rootEntity.addChild(entity)
            entity.setPosition([0.50, -0.25, 0], relativeTo: rootEntity)
        }
    }
    
    func duckMoving(duck: Entity) {
        /*
        duck.stopAllAnimations()
        
        let start = Point3D(
            x: duck.position.x,
            y: duck.position.y,
            z: duck.position.z
        )
        let end = Point3D(
            x: start.x + 2.0,
            y: start.y,
            z: start.z
        )
        let speed = 10.0
        let line = FromToByAnimation<Transform>(
            name: "line",
            from: .init(translation: simd_float3(start.vector)),
            to: .init(translation: simd_float3(end.vector)),
            duration: speed,
            bindTarget: .transform
        )
        let animation = try! AnimationResource
            .generate(with: line)
        duck.playAnimation(animation, transitionDuration: 1.0, startsPaused: false)
        */
    }
}

#Preview {
    ImmersiveView()
        .previewLayout(.sizeThatFits)
}

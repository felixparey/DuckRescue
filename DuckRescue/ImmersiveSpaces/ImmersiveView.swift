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
        RealityView { content, attachments in
            content.add(rootEntity)
            rootEntity.position  = .init(x: 0, y: 1.7, z: -1.7)
            
            appState.reset()
            
            buildAttachments(attachments)
            
            // Recursive run move animation again after completed.
            _ = content.subscribe(to: AnimationEvents.PlaybackCompleted.self, on: appState.enemy, componentType: nil) { event in
                appState.moveEnemy()
            }
            
        } update: { updateContent, attachments in
            // TODO:
        } attachments: {
            Attachment(id: "a1") {
                ChooseLevelView()
                    .padding()
                    .glassBackgroundEffect()
            }
        }
        .gesture(dragGesture)
        /*
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
         */
    }
    
    func buildAttachments(_ attachments: RealityViewAttachments) {
        if let entity = attachments.entity(for: "a1") {
            rootEntity.addChild(entity)
            entity.setPosition([0.80, -0.25, 0], relativeTo: rootEntity)
        }
    }
}

#Preview {
    ImmersiveView()
        .previewLayout(.sizeThatFits)
}

var dragGesture : some Gesture {
    DragGesture()
        .targetedToAnyEntity()
        .onChanged { value in
            if value.entity.name == "Rubber_Duck_01_1_geometry" {
                let y = value.entity.position.y
                value.entity.position = value.convert(value.location3D, from: .local, to: value.entity.parent!)
                value.entity.position.y = y
            }
        }
}

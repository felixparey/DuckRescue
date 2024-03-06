//
//  ImmersiveView.swift
//  DuckRescue
//
//  Created by Felix Parey on 13/02/24.
//

import SwiftUI
import RealityKit
import RealityKitContent

var enemyCurrentTubeSegmentIndex: Int = 0

struct ImmersiveView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.openWindow) private var openWindow
    @Environment(\.dismissImmersiveSpace) private var dimissImmersiveSpace
    @State private var duckSubscription: EventSubscription?
    
    let timer = Timer.publish(every: 6, on: .current, in: .common).autoconnect()
    @State private var counter = 0
    
    @State private var dragStart: SIMD3<Float>?
    
    static var isGestureLock = false
    
    var body: some View {
        RealityView { content, attachments in
            content.add(rootEntity)
            rootEntity.position = .init(x: 0, y: 1.3, z: -1.7)
            
            appState.reset()
            
            buildAttachments(attachments)
            
            duckSubscription = content.subscribe(to: CollisionEvents.Began.self, on: nil){ event in
                if let duck = appState.duck, !ImmersiveView.isGestureLock {
                    appState.setDuckCollisonPartner(event.entityA, event.entityB)
                    appState.checkIfCollisionIsWorking()
                    print(event.entityB.name)
                    print("PHASE: \(appState.phase)")
                    //TODO: TEmporary changing app Phase here, just for testing
                }
            }
        } update: { updateContent, attachments in
            
        } attachments: {
            Attachment(id: "a1") {
                ChooseLevelView()
                    .padding()
                    .glassBackgroundEffect()
                    .frame(height: 80)
            }
        }
        .onChange(of: appState.phase) { oldValue, newValue in
            if oldValue == .levelRunning && newValue == .hitSomething{
                switch appState.duckCollisionPartner{
                case .Floor, .Ceiling, .Geysir, .Rat: 
                    if appState.windowCount == 0{
                        openWindow(id: "GameOver")
                        appState.windowCount = 1
                    }
                    Task{
                       await dimissImmersiveSpace()
                    }
                default: return
                }
            }else if newValue == .levelRunning{
                //TODO: Make the rat run and the geysirs do their thing
            }
            
        }
        .onReceive(timer) { time in
            if counter == 5 {
                timer.upstream.connect().cancel()
                //print("timer is canceled")
                
            } else {
                //print("moving")
                moveGasParticles()
                counter += 1
            }
        }
        .gesture(DragGesture()
            .targetedToEntity(appState.duck ?? Entity())
            .onChanged { value in
                if ImmersiveView.isGestureLock {
                    return
                }
                
                appState.phase.transition(to: .levelRunning)
                if appState.phase == .levelRunning{
                    if let duck = appState.duck, let parent = appState.duck?.parent {
                        handleDrag(value)
                        
                        if duck.position.x >= DuckDistanceXToStartEnemyMovement && !appState.isEnemyMoving {
                            appState.runEnemy()
                        }
                    }
                }
            }
            .onEnded { value in
                let tappedEntity = value.entity
                dragStart = tappedEntity.position
            })
    }
    
    func buildAttachments(_ attachments: RealityViewAttachments) {
        if let entity = attachments.entity(for: "a1") {
            rootEntity.addChild(entity)
            entity.setPosition([levelContainer.visualBounds(relativeTo: nil).center.x, -0.825, 0.15], relativeTo: rootEntity)
            entity.setOrientation(simd_quatf(Rotation3D(angle: .degrees(-15), axis: .x)), relativeTo: nil)
        }
    }
    
    @MainActor
    func handleDrag(_ value: EntityTargetValue<DragGesture.Value>) {
        let tappedEntity = value.entity
        let translation3D = value.convert(value.gestureValue.translation3D, from: .local, to: tappedEntity.parent!)
        
        let offset = SIMD3<Float>(x: Float(translation3D.x),
                                  y: Float(translation3D.y),
                                  z: Float(translation3D.z))
        
        guard let dragStart = dragStart else {
            return
        }
        
        let position = dragStart + offset
        tappedEntity.position = [tappedEntity.position.x, position.y, position.z]
    }
    
    func duckMoving(duck: Entity) {
        
        // duck.move(to: .init(translation: [2.0, 0.0, 0.0]), relativeTo: levelContainer, duration: 1.0)
        // duck.move(to: Transform(translation: [1.0, 0.0, 0.0]), relativeTo: duck.parent, duration: 5.0, timingFunction: .linear)
        
        
        
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
    
    func moveGasParticles() {
        appState.isGasMoving = true
        if appState.isGasMoving {
            if let gasAnimationPlaybackController = gasAnimationPlaybackController,
               gasAnimationPlaybackController.isPaused {
                gasAnimationPlaybackController.resume()
            }
            else {
                let duration: Double = 2.0
                
                if let gasParticles = gasParticles {
                    let newPosition: SIMD3<Float> = calculateNextGasPosition()
                    
                    gasAnimationPlaybackController = gasParticles.move(
                        to: Transform(
                            scale: SIMD3(repeating: 1.0),
                            rotation: gasParticles.orientation,
                            translation: newPosition),
                        relativeTo: gasParticles.parent,
                        duration: duration,
                        timingFunction: .linear
                    )
                }
                
            }
        }
        else if let gasAnimationPlaybackController = gasAnimationPlaybackController,
                gasAnimationPlaybackController.isPlaying {
            gasAnimationPlaybackController.pause()
        }
    }
    
    func calculateNextGasPosition() -> SIMD3<Float> {
        var x = gasParticles!.position.x
        var y = gasParticles!.position.y + tubeHeight
        
        return .init(x: x, y: y, z: gasParticles!.position.z)
    }
}

#Preview {
    ImmersiveView()
        .previewLayout(.sizeThatFits)
}






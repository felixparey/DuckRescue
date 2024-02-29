//
//  GlobalEntities.swift
//  DuckRescue
//
//  Created by Alexandr Chubutkin on 21/02/24.
//

import Foundation
import RealityKit

    let rootEntity = Entity()
    let levelContainer = Entity()
    
    var tube: Entity? = nil
    var tubeStraight: Entity? = nil
    var tubeCorner: Entity? = nil

    var enemy: Entity? = nil
    var enemyAnimationPlaybackController: AnimationPlaybackController?
    
    var gasParticles: Entity? = nil
    var gasAnimationPlaybackController: AnimationPlaybackController?

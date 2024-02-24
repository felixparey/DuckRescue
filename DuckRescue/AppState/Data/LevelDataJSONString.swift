//
//  TubeData.swift
//  DuckRescue
//
//  Created by Alexandr Chubutkin on 22/02/24.
//

import Foundation

let LevelDataJSONString = """
[
    [
        { "name": "straight", "rotation": 0 },
        { "name": "straight", "rotation": 0 },
        { "name": "corner_1", "rotation": 90 },

        { "name": "corner_4", "rotation": 90 },
        { "name": "straight", "rotation": 0 },
        { "name": "corner_2", "rotation": 90 },

        { "name": "corner_3", "rotation": 90 },
        { "name": "straight", "rotation": 0 },
        { "name": "straight", "rotation": 0 }
    ],
    [
        { "name": "straight", "rotation": 0 },
        { "name": "corner_1", "rotation": 90 },
        { "name": "Empty", "rotation": 0 },

        { "name": "Empty", "rotation": 90 },
        { "name": "corner_3", "rotation": 0 },
        { "name": "corner_1", "rotation": 90 },

        { "name": "straight", "rotation": 0 },
        { "name": "straight", "rotation": 0 },
        { "name": "corner_2", "rotation": 90 }
    ],
    [
        { "name": "corner", "rotation": 90 },
        { "name": "straight", "rotation": 0 },
        { "name": "corner", "rotation": 90 },

        { "name": "straight", "rotation": 90 },
        { "name": "straight", "rotation": 0 },
        { "name": "corner", "rotation": 90 },

        { "name": "corner", "rotation": 90 },
        { "name": "straight", "rotation": 0 },
        { "name": "straight", "rotation": 0 }
    ]
]
"""

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
        { "name": "straight", "rotation": 0, "order": 1 },
        { "name": "straight", "rotation": 0, "order": 2 },
        { "name": "corner_1", "rotation": 90, "order": 3 },

        { "name": "corner_4", "rotation": 90, "order": 6 },
        { "name": "straight", "rotation": 0, "order": 5 },
        { "name": "corner_2", "rotation": 90, "order": 4 },

        { "name": "corner_3", "rotation": 90, "order": 7 },
        { "name": "straight", "rotation": 0, "order": 8 },
        { "name": "straight", "rotation": 0, "order": 9 }
    ],
    [
        { "name": "straight", "rotation": 0, "order": 1 },
        { "name": "corner_1", "rotation": 90, "order": 2 },
        { "name": "Empty", "rotation": 0, "order": 0 },

        { "name": "Empty", "rotation": 90, "order": 0 },
        { "name": "corner_3", "rotation": 0, "order": 3 },
        { "name": "corner_1", "rotation": 90, "order": 4 },

        { "name": "straight", "rotation": 0, "order": 7 },
        { "name": "straight", "rotation": 0, "order": 6 },
        { "name": "corner_2", "rotation": 90, "order": 5 }
    ],
    [
        { "name": "corner_4", "rotation": 90, "order": 5 },
        { "name": "straight", "rotation": 0, "order": 4 },
        { "name": "corner_1", "rotation": 90, "order": 3 },

        { "name": "straight", "rotation": 90, "order": 6 },
        { "name": "straight", "rotation": 0, "order": 1 },
        { "name": "corner_2", "rotation": 90, "order": 2 },

        { "name": "corner_3", "rotation": 90, "order": 7 },
        { "name": "straight", "rotation": 0, "order": 8 },
        { "name": "straight", "rotation": 0, "order": 9 }
    ]
]
"""

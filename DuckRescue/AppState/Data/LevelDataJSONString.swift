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
        { "name": "StraightScene", "rotation": 0, "order": 1 },
        { "name": "StraightScene", "rotation": 0, "order": 2 },
        { "name": "StraightScene", "rotation": 0, "order": 3 },
        { "name": "StraightScene", "rotation": 0, "order": 4 },
        { "name": "Corner1", "rotation": 0, "order": 5 },

        { "name": "Corner4", "rotation": 0, "order": 10 },
        { "name": "StraightScene", "rotation": 0, "order": 9 },
        { "name": "StraightScene", "rotation": 0, "order": 8 },
        { "name": "StraightScene", "rotation": 0, "order": 7 },
        { "name": "Corner2", "rotation": 0, "order": 6 },

        { "name": "Corner3", "rotation": 0, "order": 11 },
        { "name": "StraightScene", "rotation": 0, "order": 12 },
        { "name": "StraightScene", "rotation": 0, "order": 13 },
        { "name": "StraightScene", "rotation": 0, "order": 14 },
        { "name": "Corner1", "rotation": 0, "order": 15 },

        { "name": "Corner4", "rotation": 0, "order": 20 },
        { "name": "StraightScene", "rotation": 0, "order": 19 },
        { "name": "StraightScene", "rotation": 0, "order": 18 },
        { "name": "StraightScene", "rotation": 0, "order": 17 },
        { "name": "Corner2", "rotation": 0, "order": 16 },

        { "name": "Corner3", "rotation": 0, "order": 21 },
        { "name": "StraightScene", "rotation": 0, "order": 22 },
        { "name": "StraightScene", "rotation": 0, "order": 23 },
        { "name": "StraightScene", "rotation": 0, "order": 24 },
        { "name": "EndPieceScene", "rotation": 0, "order": 25 }
    ],
    [
        { "name": "Straight", "rotation": 0, "order": 1 },
        { "name": "Corner1", "rotation": 0, "order": 2 },
        { "name": "Empty", "rotation": 0, "order": 0 },
        { "name": "Empty", "rotation": 0, "order": 0 },
        { "name": "Empty", "rotation": 0, "order": 0 },

        { "name": "Corner4", "rotation": 0, "order": 4 },
        { "name": "Corner2", "rotation": 0, "order": 3 },
        { "name": "Empty", "rotation": 0, "order": 0 },
        { "name": "Empty", "rotation": 0, "order": 0 },
        { "name": "Empty", "rotation": 0, "order": 0 },

        { "name": "Corner3", "rotation": 0, "order": 5 },
        { "name": "Straight", "rotation": 0, "order": 6 },
        { "name": "Straight", "rotation": 0, "order": 7 },
        { "name": "Corner1", "rotation": 0, "order": 8 },
        { "name": "Empty", "rotation": 0, "order": 0 },

        { "name": "Empty", "rotation": 0, "order": 0 },
        { "name": "Corner4", "rotation": 0, "order": 11 },
        { "name": "Straight", "rotation": 0, "order": 10 },
        { "name": "Corner2", "rotation": 0, "order": 9 },
        { "name": "Empty", "rotation": 0, "order": 1 },

        { "name": "Empty", "rotation": 0, "order": 0 },
        { "name": "Corner3", "rotation": 0, "order": 12 },
        { "name": "Straight", "rotation": 0, "order": 13 },
        { "name": "Straight", "rotation": 0, "order": 14 },
        { "name": "Straight", "rotation": 0, "order": 15 }
    ],
    [
        { "name": "Straight", "rotation": 0, "order": 1 },
        { "name": "Straight", "rotation": 0, "order": 2 },
        { "name": "Corner1", "rotation": 0, "order": 3 },
        { "name": "Empty", "rotation": 0, "order": 0 },
        { "name": "Empty", "rotation": 0, "order": 0 },

        { "name": "Empty", "rotation": 0, "order": 0 },
        { "name": "Corner4", "rotation": 0, "order": 6 },
        { "name": "Corner2", "rotation": 0, "order": 5 },
        { "name": "Empty", "rotation": 0, "order": 0 },
        { "name": "Empty", "rotation": 0, "order": 0 },

        { "name": "Empty", "rotation": 0, "order": 0 },
        { "name": "Corner3", "rotation": 0, "order": 7 },
        { "name": "Straight", "rotation": 0, "order": 8 },
        { "name": "Corner1", "rotation": 0, "order": 9 },
        { "name": "Empty", "rotation": 0, "order": 0 },

        { "name": "Empty", "rotation": 0, "order": 0 },
        { "name": "Corner4", "rotation": 0, "order": 12 },
        { "name": "Straight", "rotation": 0, "order": 11 },
        { "name": "Corner2", "rotation": 0, "order": 10 },
        { "name": "Empty", "rotation": 0, "order": 0 },

        { "name": "Empty", "rotation": 0, "order": 0 },
        { "name": "Corner3", "rotation": 0, "order": 13 },
        { "name": "Straight", "rotation": 0, "order": 14 },
        { "name": "Straight", "rotation": 0, "order": 15 },
        { "name": "Straight", "rotation": 0, "order": 16 }
    ]
]
"""

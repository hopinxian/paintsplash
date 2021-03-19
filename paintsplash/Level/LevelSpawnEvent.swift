//
//  LevelSpawnEvent.swift
//  paintsplash
//
//  Created by Ho Pin Xian on 18/3/21.
//

import UIKit

struct LevelSpawnEvent: Comparable {
    static func < (lhs: LevelSpawnEvent, rhs: LevelSpawnEvent) -> Bool {
        return lhs.time < rhs.time
    }
    
    static func == (lhs: LevelSpawnEvent, rhs: LevelSpawnEvent) -> Bool {
        return lhs.time == rhs.time &&
            lhs.spawnObject == rhs.spawnObject
    }
    
    var time: Double
    var spawnObject: LevelSpawnType
}

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
            lhs.color == rhs.color &&
            lhs.location == rhs.location
    }
    
    var time: Double
    var color: PaintColor?
    var location: Vector2D?
    // var enemyType: SpawnEntityType
    // var enemyBehaviour: AIBehaviour
    
    // additional var information for type of enemy
    // can be enemy or enemy spawner or maybe canvas
    // shld get enum for all possible enemy types
    // right now support only enemy spawning in level first
    
    static var spawnBoundary = Vector2D(UIScreen.main.bounds.width / 3,                                        UIScreen.main.bounds.height / 3)
    
    func constructEvent() -> SpawnAIEntityEvent {
        let absX = LevelSpawnEvent.spawnBoundary.x
        let absY = LevelSpawnEvent.spawnBoundary.y
        let randomX = Double.random(in: -absX..<absX)
        let randomY = Double.random(in: -absY..<absY)
        let location = self.location ?? Vector2D(randomX, randomY)
        let color = self.color ?? PaintColor.allCases.shuffled()[0]
        
        // switch statement for returning the entity event
        let spawnEntityEvent = SpawnAIEntityEvent(spawnEntityType: .enemy(location: location, color: color))
        return spawnEntityEvent
    }
}

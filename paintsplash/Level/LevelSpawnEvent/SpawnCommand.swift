//
//  SpawnCommand.swift
//  paintsplash
//
//  Created by Ho Pin Xian on 25/3/21.
//

class SpawnCommand: Comparable, Identifiable {
    static func == (lhs: SpawnCommand, rhs: SpawnCommand) -> Bool {
        lhs.time == rhs.time &&
            lhs.id == rhs.id
    }

    static func < (lhs: SpawnCommand, rhs: SpawnCommand) -> Bool {
        lhs.time < rhs.time
    }

    func spawnIntoLevel(gameInfo: GameInfo) {

    }

    var time: Double = 0.0
}

extension SpawnCommand {
    func getLocation(location: Vector2D?, gameInfo: GameInfo) -> Vector2D {
        if let location = location {
            return location
        }
        
        let randomX = Double.random(in: Constants.PLAYER_MOVEMENT_BOUNDS.minX..<Constants.PLAYER_MOVEMENT_BOUNDS.maxX)
        let randomY = Double.random(in: Constants.PLAYER_MOVEMENT_BOUNDS.minY..<Constants.PLAYER_MOVEMENT_BOUNDS.maxY)
        let location = Vector2D(randomX, randomY)
        if intersectPlayer(location: location, gameInfo: gameInfo) {
            return getLocation(location: nil, gameInfo: gameInfo)
        }
        return location
    }
    
    private func intersectPlayer(location: Vector2D, gameInfo: GameInfo) -> Bool {
        let x = gameInfo.playerPosition.x
        let y = gameInfo.playerPosition.y
        if location.x >= x - 128 &&
            location.x <= x + 128 &&
            location.y <= y + 128 &&
            location.y >= y - 128 {
            return true
        }
        return false
    }

    func getColor(color: PaintColor?, gameInfo: GameInfo) -> PaintColor {
        let color = color ?? PaintColor.allCases.shuffled()[0]
        return color
    }

    func getVelocity(velocity: Vector2D?, gameInfo: GameInfo) -> Vector2D {
        let velocity = velocity ?? Vector2D(0.2, 0)
        return velocity
    }

    func getCanvasSize(size: Vector2D?, gameInfo: GameInfo) -> Vector2D {
        size ?? Level.defaultCanvasSize
    }

    func getSpawnInterval(interval: Double?, gameInfo: GameInfo) -> Double {
        interval ?? Level.defaultInterval
    }
}

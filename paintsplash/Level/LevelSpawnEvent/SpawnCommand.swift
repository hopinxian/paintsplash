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

    func spawnIntoLevel(gameInfo: AIGameInfo) {

    }

    var time: Double = 0.0
}

extension SpawnCommand {
    func getLocation(location: Vector2D?, gameInfo: AIGameInfo) -> Vector2D {
        let randomX = Double.random(in: Constants.PLAYER_MOVEMENT_BOUNDS.minX..<Constants.PLAYER_MOVEMENT_BOUNDS.maxX)
        let randomY = Double.random(in: Constants.PLAYER_MOVEMENT_BOUNDS.minY..<Constants.PLAYER_MOVEMENT_BOUNDS.maxY)
        let location = location ?? Vector2D(randomX, randomY)
        return location
    }

    func getColor(color: PaintColor?, gameInfo: AIGameInfo) -> PaintColor {
        let color = color ?? PaintColor.allCases.shuffled()[0]
        return color
    }

    func getVelocity(velocity: Vector2D?, gameInfo: AIGameInfo) -> Vector2D {
        let velocity = velocity ?? Vector2D(0.2, 0)
        return velocity
    }

    func getCanvasSize(size: Vector2D?, gameInfo: AIGameInfo) -> Vector2D {
        size ?? Level.defaultCanvasSize
    }

    func getSpawnInterval(interval: Double?, gameInfo: AIGameInfo) -> Double {
        interval ?? Level.defaultInterval
    }
}

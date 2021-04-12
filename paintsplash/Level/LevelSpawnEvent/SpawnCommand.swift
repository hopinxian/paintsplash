//
//  SpawnCommand.swift
//  paintsplash
//
//  Created by Ho Pin Xian on 25/3/21.
//

class SpawnCommand: Comparable, Identifiable {
    static let rng = RandomNumber(200)
    
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
    func getLocation(location: Vector2D?, gameInfo: GameInfo, size: Vector2D) -> Vector2D {
        if let location = location {
            return location
        }

        let bounds = Constants.PLAYER_MOVEMENT_BOUNDS

        let randomX = SpawnCommand.rng.nextUniform(bounds.minX..<bounds.maxX)
        let randomY = SpawnCommand.rng.nextUniform(bounds.minY..<bounds.maxY)
        let location = Vector2D(randomX, randomY)
        if intersectPlayer(location: location, gameInfo: gameInfo) {
            return getLocation(location: nil, gameInfo: gameInfo, size: size)
        }

        if !bounds.inset(by: size).contains(location) {
            return getLocation(location: nil, gameInfo: gameInfo, size: size)
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
        if let color = color {
            return color
        }
        let colors = PaintColor.allCases
        let length = colors.count
        let randomColor = colors[SpawnCommand.rng.nextInt(0..<length)]
        return randomColor
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

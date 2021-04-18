//
//  SpawnCommand.swift
//  paintsplash
//
//  Created by Ho Pin Xian on 25/3/21.
//

/**
 `SpawnCommand` is a parent class that can spawn an object when a level is running.
 SpawnCommands can be sorted by the time of spawning.
 */
class SpawnCommand: Comparable, Identifiable {
    static let rng = RandomNumber(200)

    var time: Double = 0.0

    static func == (lhs: SpawnCommand, rhs: SpawnCommand) -> Bool {
        lhs.time == rhs.time &&
            lhs.id == rhs.id
    }

    static func < (lhs: SpawnCommand, rhs: SpawnCommand) -> Bool {
        lhs.time < rhs.time
    }

    func spawnIntoLevel(gameInfo: GameInfo) {
    }
}

extension SpawnCommand {

    /// Returns a random location if the given location is nil,
    /// else returns the given location.
    func getLocation(location: Vector2D?, gameInfo: GameInfo, size: Vector2D) -> Vector2D {
        if let location = location {
            return location
        }

        let bounds = Constants.PLAYER_MOVEMENT_BOUNDS

        let randomX = SpawnCommand.rng.nextUniform(bounds.minX..<bounds.maxX)
        let randomY = SpawnCommand.rng.nextUniform(bounds.minY..<bounds.maxY)
        let location = Vector2D(randomX, randomY)

        if intersectPlayer(location: location, gameInfo: gameInfo) ||
            !bounds.inset(by: size).contains(location) {
            return getLocation(location: nil, gameInfo: gameInfo, size: size)
        }

        return location
    }

    /// Returns true if the given location intersects with the player.
    private func intersectPlayer(location: Vector2D, gameInfo: GameInfo) -> Bool {
        let x = gameInfo.playerPosition.x
        let y = gameInfo.playerPosition.y
        if location.x >= x - Constants.PLAYER_SIZE.x &&
            location.x <= x + Constants.PLAYER_SIZE.x &&
            location.y <= y + Constants.PLAYER_SIZE.y &&
            location.y >= y - Constants.PLAYER_SIZE.y {
            return true
        }
        return false
    }

    /// Returns a random color if the given color is nil,
    /// else returns the given color.
    func getColor(color: PaintColor?, gameInfo: GameInfo) -> PaintColor {
        if let color = color {
            return color
        }

        let colors = PaintColor.allCases
        let length = colors.count
        let randomColor = colors[SpawnCommand.rng.nextInt(0..<length)]
        return randomColor
    }

    /// Returns a random set of 1 to 3 paint colors.
    func getRandomRequest() -> Set<PaintColor> {
        let randomNumber = SpawnCommand.rng.nextInt(1..<3)
        var request = Set<PaintColor>()
        let colors = PaintColor.baseColors + PaintColor.secondaryColors
        let length = colors.count
        for _ in 1...randomNumber {
            let randomColor = colors[SpawnCommand.rng.nextInt(0..<length)]
            request.insert(randomColor)
        }
        return request
    }
}

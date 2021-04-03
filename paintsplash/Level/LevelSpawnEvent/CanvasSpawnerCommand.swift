//
//  CanvasSpawnerCommand.swift
//  paintsplash
//
//  Created by Ho Pin Xian on 25/3/21.
//

class CanvasSpawnerCommand: SpawnCommand {
    var location: Vector2D?
    var velocity: Vector2D?
    var canvasSize: Vector2D?
    var spawnInterval: Double?
    var endX: Double

    init(endX: Double) {
        self.endX = endX
    }

    override func spawnIntoLevel(gameInfo: GameInfo) {
        if gameInfo.numberOfEnemies >= Level.enemyCapacity {
            return
        }

        let eventLocation = getLocation(location: location, gameInfo: gameInfo)
        let eventVelocity = getVelocity(velocity: velocity, gameInfo: gameInfo)
        let eventSpawnInterval = getSpawnInterval(interval: spawnInterval, gameInfo: gameInfo)
        let canvasSpawner = CanvasSpawner(
            initialPosition: eventLocation,
            canvasVelocity: eventVelocity,
            spawnInterval: eventSpawnInterval
        )
        canvasSpawner.spawn()
    }
}

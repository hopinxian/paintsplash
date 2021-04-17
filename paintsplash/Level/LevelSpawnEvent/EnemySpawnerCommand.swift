//
//  EnemySpawnerCommand.swift
//  paintsplash
//
//  Created by Ho Pin Xian on 25/3/21.
//

/**
 A command that spawns an enemy spawner of the given location and color.
 If location or color is not given, they are randomized when spawned.
 */
class EnemySpawnerCommand: SpawnCommand {
    var location: Vector2D?
    var color: PaintColor?

    override func spawnIntoLevel(gameInfo: GameInfo) {
        if gameInfo.numberOfEnemies >= Level.enemyCapacity {
            return
        }

        let eventLocation = getLocation(location: location,
                                        gameInfo: gameInfo,
                                        size: Constants.ENEMY_SPAWNER_SIZE)
        let eventColor = getColor(color: color, gameInfo: gameInfo)

        let enemySpawner = EnemySpawner(initialPosition: eventLocation, color: eventColor)
        enemySpawner.spawn()
    }
}

//
//  EnemySpawnerCommand.swift
//  paintsplash
//
//  Created by Ho Pin Xian on 25/3/21.
//

class EnemySpawnerCommand: SpawnCommand {
    var location: Vector2D?
    var color: PaintColor?

    override func spawnIntoLevel(gameInfo: GameInfo) {
        let eventLocation = getLocation(location: location, gameInfo: gameInfo)
        let eventColor = getColor(color: color, gameInfo: gameInfo)

        let enemySpawner = EnemySpawner(initialPosition: eventLocation, color: eventColor)
        enemySpawner.spawn()
    }
}

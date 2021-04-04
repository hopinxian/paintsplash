//
//  SpawnEnemyCommand.swift
//  paintsplash
//
//  Created by Ho Pin Xian on 25/3/21.
//

class EnemyCommand: SpawnCommand {
    var location: Vector2D?
    var color: PaintColor?

    override func spawnIntoLevel(gameInfo: GameInfo) {
        if gameInfo.numberOfEnemies >= Level.enemyCapacity {
            return
        }

        let eventLocation = getLocation(location: location, gameInfo: gameInfo, size: Constants.ENEMY_SIZE)
        let eventColor = getColor(color: color, gameInfo: gameInfo)

        let enemy = Enemy(initialPosition: eventLocation, color: eventColor)
        enemy.spawn()
    }
}

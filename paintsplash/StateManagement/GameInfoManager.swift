//
//  GameInfoManager.swift
//  paintsplash
//
//  Created by admin on 1/4/21.
//

class GameInfoManager {
    var gameInfo: GameInfo

    init(gameInfo: GameInfo) {
        self.gameInfo = gameInfo
        EventSystem.entityChangeEvents
            .addEntityEvent.subscribe(listener: { [weak self] in
                                        self?.updateAddEntity(event: $0)
            })

        EventSystem.entityChangeEvents
            .removeEntityEvent.subscribe(listener: { [weak self] in
                                            self?.updateRemoveEntity(event: $0)
            })

        EventSystem.playerActionEvent
            .playerMovementEvent.subscribe(listener: { [weak self] in
                                            self?.updatePlayerMove(event: $0)
            })
    }

    func updatePlayerMove(event: PlayerMovementEvent) {
        gameInfo.playerPosition = event.location
    }

    func updateAddEntity(event: AddEntityEvent) {
        switch event.entity {
        case let enemy as Enemy:
            gameInfo.numberOfEnemies += 1
            gameInfo.existingEnemyColors[enemy.color, default: 0] += 1
        case let enemy as EnemySpawner:
            gameInfo.numberOfEnemies += 1
            gameInfo.existingEnemyColors[enemy.color, default: 0] += 1
        case let request as CanvasRequest:
            for color in request.requiredColors {
                gameInfo.requiredCanvasColors[color, default: 0] += 1
            }
        case let drop as PaintAmmoDrop:
            gameInfo.existingDropColors[drop.color, default: 0] += 1
            gameInfo.numberOfDrops += 1
        default:
            return
        }
    }

    func updateRemoveEntity(event: RemoveEntityEvent) {
        switch event.entity {
        case let enemy as Enemy:
            gameInfo.numberOfEnemies -= 1
            gameInfo.existingEnemyColors[enemy.color]? -= 1
        case let enemy as EnemySpawner:
            gameInfo.numberOfEnemies -= 1
            gameInfo.existingEnemyColors[enemy.color]? -= 1
        case let request as CanvasRequest:
            for color in request.requiredColors {
                gameInfo.requiredCanvasColors[color]? -= 1
            }
        case let drop as PaintAmmoDrop:
            gameInfo.existingDropColors[drop.color]? -= 1
            gameInfo.numberOfDrops -= 1
        default:
            return
        }
    }
}

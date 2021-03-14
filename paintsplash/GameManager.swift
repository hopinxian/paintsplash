//
//  GameManager.swift
//  paintsplash
//
//  Created by Farrell Nah on 13/3/21.
//

class GameManager {
    var gameScene: GameScene
    var entities = Set<GameEntity>()

    var currentPlayerPosition: Vector2D {
        player.position
    }

    var currentPlayerVelocity: Vector2D {
        get {
            player.velocity
        }
        set {   
            player.velocity = newValue
            print(player.velocity)
        }
    }

    private var player: Player

    init(gameScene: GameScene) {
        self.gameScene = gameScene

        // add player
        player = Player(initialPosition: Vector2D(50, 50), initialVelocity: Vector2D(-1, 0))
        entities.insert(player)
        player.spawn(gameManager: self)

        // add enemies
        let enemy = Enemy(initialPosition: Vector2D(50, 50), initialVelocity: Vector2D(-1, 0))
        entities.insert(enemy)
        enemy.spawn(gameManager: self)
    }

    func getRenderSystem() -> RenderSystem {
        gameScene
    }

    func getCollisionSystem() -> CollisionSystem {
        gameScene
    }

    func getEnemies() -> [Enemy] {
        entities.compactMap({ $0 as? Enemy })
    }

    func addObject(_ object: GameEntity) {
        entities.insert(object)
    }

    func removeObject(_ object: GameEntity) {
        entities.remove(object)
    }

    func update() {
        for entity in entities {
            entity.update(gameManager: self)
        }
    }
}

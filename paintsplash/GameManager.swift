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
        }
    }

    private var player: Player

    var aiSystem: GameManagerAISystem?

    init(gameScene: GameScene) {
        self.gameScene = gameScene

        player = Player(initialPosition: Vector2D(50, 50), initialVelocity: Vector2D(-1, 0))
        entities.insert(player)

        self.aiSystem = GameManagerAISystem(gameManager: self)

        self.aiSystem?.addEnemy(at: Vector2D(50, 50))
        self.aiSystem?.addEnemySpawner(at: Vector2D(200, 50))

        setupGame()
        setupViewChangeListener()
    }

    func setupGame() {
        player.spawn(gameManager: self)

        let joystick = Joystick(position: Vector2D(Double(150) / -2 + 100, -200))
        joystick.spawn(gameManager: self)

        let attackButton = AttackButton(position: Vector2D(Double(150) / 2 + 100, -200))
        attackButton.spawn(gameManager: self)
    }

    private func setupViewChangeListener() {
        EventSystem.changeViewEvent.subscribe { event in
            switch event.changeViewEventType {
            case .changeAnimation(let renderable):
                self.getRenderSystem().updateRenderableAnimation(renderable)
            }
        }
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

    func removeAIEntity(aiEntity: AIEntity) {
        aiSystem?.remove(aiEntity: aiEntity)
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

        aiSystem?.updateAIEntities()
    }
}

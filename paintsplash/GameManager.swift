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

        player = Player(initialPosition: Vector2D(-250, 0), initialVelocity: Vector2D(1, 0))

        EventSystem.entityChangeEvents.addEntityEvent.subscribe(listener: onAddEntity)
        EventSystem.entityChangeEvents.removeEntityEvent.subscribe(listener: onRemoveEntity)
        
        setupGame()
    }

    func setupGame() {
        let ammoDrop = PaintAmmoDrop(color: .red, position: Vector2D(0, 0))

        ammoDrop.spawn(gameManager: self)
        
        let ammoDrop2 = PaintAmmoDrop(color: .yellow, position: Vector2D(50, 50))
        
        ammoDrop2.spawn(gameManager: self)
        
        player.spawn(gameManager: self)


        guard let paintGun = player.paintWeaponsSystem.availableWeapons.compactMap({ $0 as? PaintGun }).first else {
            fatalError("PaintGun not setup properly")
        }

        let paintGunUI = PaintGunAmmoDisplay(weaponData: paintGun)
        paintGunUI.spawn(gameManager: self)

        guard let paintBucket = player.paintWeaponsSystem.availableWeapons.compactMap({ $0 as? Bucket }).first else {
            fatalError("PaintBucket not setup properly")
        }

        let paintBucketUI = PaintBucketAmmoDisplay(weaponData: paintBucket)
        paintBucketUI.spawn(gameManager: self)

        let joystick = Joystick(position: Vector2D(-700, -500))
        joystick.spawn(gameManager: self)

        let attackButton = AttackButton(position: Vector2D(700, -500))
        attackButton.spawn(gameManager: self)

        let canvasRequestUI = VerticalStackDisplay(position: Vector2D(-300, 0),
                                                   size: Vector2D(200, 500),
                                                   backgroundSprite: "WhiteSquare")
        canvasRequestUI.spawn(gameManager: self)

        self.aiSystem = GameManagerAISystem(gameManager: self)

        // self.aiSystem?.addEnemy(at: Vector2D(50, 50), with: .yellow)
        // self.aiSystem?.addEnemySpawner(at: Vector2D(200, 50), with: .red)
        
        let canvasSpawner = CanvasSpawner(initialPosition: Vector2D(-800, 500),
                canvasVelocity: Vector2D(0.2, 0))
        self.aiSystem?.add(aiEntity: canvasSpawner)
    }

    func getRenderSystem() -> RenderSystem {
        gameScene
    }

    func getCollisionSystem() -> CollisionSystem {
        gameScene
    }

    private func getEnemies() -> [Enemy] {
        entities.compactMap({ $0 as? Enemy })
    }

    private func removeAIEntity(aiEntity: AIEntity) {
        aiSystem?.remove(aiEntity: aiEntity)
    }

    private func onAddEntity(event: AddEntityEvent) {
        event.entity.spawn(gameManager: self)
    }

    func addObject(_ object: GameEntity) {
        entities.insert(object)
    }

    private func onRemoveEntity(event: RemoveEntityEvent) {
        event.entity.destroy(gameManager: self)
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

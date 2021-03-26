//
//  GameScene.swift
//  paintsplash
//
//  Created by Praveen Bala on 8/3/21.
//

import SpriteKit

class GameScene: SKScene, GameManager {
    var entities = Set<GameEntity>()

    var currentLevel: Level?

    var aiSystem: StateManagerSystem!
    var audioManager: AudioSystem!
    var renderSystem: RenderSystem!
    var animationSystem: AnimationSystem!
    var collisionSystem: CollisionSystem!
    var movementSystem: MovementSystem!

    private var collisionDetector: SKCollisionDetector!

    var player: Player!

    override func didMove(to view: SKView) {
        // Get label node from scene and store it for use later
        isAccessibilityElement = false

        SpaceConverter.modelSize = Constants.MODEL_WORLD_SIZE
        SpaceConverter.screenSize = Vector2D(self.size.width, self.size.height)

        let background = SKSpriteNode(imageNamed: "floor")
        background.zPosition = CGFloat(Constants.ZPOSITION_FLOOR)
        background.size = SpaceConverter.modelToScreen(Constants.MODEL_WORLD_SIZE)
        self.addChild(background)

        EventSystem.entityChangeEvents.addEntityEvent.subscribe(listener: onAddEntity)
        EventSystem.entityChangeEvents.removeEntityEvent.subscribe(listener: onRemoveEntity)

        setupGame()
    }

    func setupGame() {
        setUpSystems()
        setUpEntities()
        setUpUI()
        setUpAudio()
    }

    func setUpSystems() {
        let skRenderSystem = SKRenderSystem(scene: self)
        self.renderSystem = skRenderSystem

        let skCollisionSystem = SKCollisionSystem(renderSystem: skRenderSystem)
        self.collisionSystem = skCollisionSystem

        self.collisionDetector = SKCollisionDetector(renderSystem: skRenderSystem, collisionSystem: skCollisionSystem)
        physicsWorld.contactDelegate = collisionDetector

        self.animationSystem = SKAnimationSystem(renderSystem: skRenderSystem)

        self.aiSystem = GameStateManagerSystem()

        self.audioManager = AudioManager()

        self.movementSystem = FrameMovementSystem()
    }

    func setUpEntities() {
        player = Player(initialPosition: Vector2D.zero)
        player.spawn()

        let canvasSpawner = CanvasSpawner(
            initialPosition: Constants.CANVAS_SPAWNER_POSITION,
            canvasVelocity: Vector2D(0.4, 0),
            spawnInterval: 10
        )
        canvasSpawner.spawn()

        let canvasManager = CanvasRequestManager()
        canvasManager.spawn()

        let canvasEndMarker = CanvasEndMarker(size: Constants.CANVAS_END_MARKER_SIZE,
                                              position: Constants.CANVAS_END_MARKER_POSITION)
        canvasEndMarker.spawn()

        currentLevel = Level.getDefaultLevel(gameManager: self, canvasManager: canvasManager)
        currentLevel?.run()
    }

    func setUpAudio() {
        self.audioManager.playMusic(Music.backgroundMusic)
    }

    func setUpUI() {
        guard let paintGun = player.multiWeaponComponent.availableWeapons.compactMap({ $0 as? PaintGun }).first else {
            fatalError("PaintGun not setup properly")
        }

        let paintGunUI = PaintGunAmmoDisplay(weaponData: paintGun)
        paintGunUI.spawn()
        paintGunUI.ammoDisplayView.animationComponent.animate(animation: WeaponAnimations.selectWeapon, interupt: true)

        guard let paintBucket = player.multiWeaponComponent.availableWeapons.compactMap({ $0 as? Bucket }).first else {
            fatalError("PaintBucket not setup properly")
        }

        let paintBucketUI = PaintBucketAmmoDisplay(weaponData: paintBucket)
        paintBucketUI.spawn()
        paintBucketUI.ammoDisplayView.animationComponent.animate(
            animation: WeaponAnimations.unselectWeapon,
            interupt: true
        )

        let joystick = Joystick()
        joystick.spawn()

        let attackButton = AttackButton()
        attackButton.spawn()

        let playerHealthUI = PlayerHealthDisplay(startingHealth: player.healthComponent.currentHealth)
        playerHealthUI.spawn()

        let bottombar = UIBar(
            position: Constants.BOTTOM_BAR_POSITION,
            size: Constants.BOTTOM_BAR_SIZE,
            spritename: Constants.BOTTOM_BAR_SPRITE
        )
        bottombar.spawn()

        let topBar = UIBar(
            position: Constants.TOP_BAR_POSITION,
            size: Constants.TOP_BAR_SIZE,
            spritename: Constants.TOP_BAR_SPRITE
        )
        topBar.spawn()
    }

    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered

        update()
    }

    private func onAddEntity(event: AddEntityEvent) {
        addObject(event.entity)
    }

    func addObject(_ object: GameEntity) {
        entities.insert(object)
        renderSystem.addEntity(object)
        aiSystem.addEntity(object)
        collisionSystem.addEntity(object)
        movementSystem.addEntity(object)
        animationSystem.addEntity(object)
    }

    private func onRemoveEntity(event: RemoveEntityEvent) {
        removeObject(event.entity)
    }

    func removeObject(_ object: GameEntity) {
        entities.remove(object)
        renderSystem.removeEntity(object)
        aiSystem.removeEntity(object)
        collisionSystem.removeEntity(object)
    }

    func update() {
        currentLevel?.update()
        let entityList = Array(entities)
        aiSystem.updateEntities()
        renderSystem.updateEntities()
        animationSystem.updateEntities()
        collisionSystem.updateEntities()
        movementSystem.updateEntities()
        entityList.forEach({ $0.update() })
    }
}

extension SKNode: UIAccessibilityIdentification {
   public var accessibilityIdentifier: String? {
       get {
           super.accessibilityLabel
       }
       set(accessibilityIdentifier) {
           super.accessibilityLabel = accessibilityIdentifier
       }
   }
}

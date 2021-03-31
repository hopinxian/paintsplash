//
//  MultiplayerServer.swift
//  paintsplash
//
//  Created by Farrell Nah on 31/3/21.
//

class MultiplayerServer: GameManager {
    var entities = Set<GameEntity>()
    var room: RoomInfo
    var connectionHandler: ConnectionHandler
    var gameScene: GameScene
    var currentLevel: Level?

    var renderSystem: RenderSystem!
    var animationSystem: AnimationSystem!
    var aiSystem: StateManagerSystem!
//    var audioManager: AudioSystem!
    var collisionSystem: CollisionSystem!
    var movementSystem: MovementSystem!

    private var collisionDetector: SKCollisionDetector!

    var player: Player!

    init(roomInfo: RoomInfo, gameScene: GameScene) {
        self.gameScene = gameScene
        self.connectionHandler = FirebaseConnectionHandler()
        self.room = roomInfo

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
        let skRenderSystem = SKRenderSystem(scene: gameScene)
        self.renderSystem = skRenderSystem

        let skCollisionSystem = SKCollisionSystem(renderSystem: skRenderSystem)
        self.collisionSystem = skCollisionSystem

        self.collisionDetector = SKCollisionDetector(renderSystem: skRenderSystem, collisionSystem: skCollisionSystem)
        gameScene.physicsWorld.contactDelegate = collisionDetector

        self.animationSystem = SKAnimationSystem(renderSystem: skRenderSystem)

        self.aiSystem = GameStateManagerSystem()

//        self.audioManager = AudioManager()

        self.movementSystem = FrameMovementSystem()
    }

    func setUpEntities() {
        let background = Background()
        background.spawn()

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
//        self.audioManager.playMusic(Music.backgroundMusic)
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
        movementSystem.removeEntity(object)
        animationSystem.removeEntity(object)
    }

    func update() {
        currentLevel?.update()
        aiSystem.updateEntities()
        collisionSystem.updateEntities()
        movementSystem.updateEntities()
        sendGameState()
        renderSystem.updateEntities()
        animationSystem.updateEntities()
        entities.forEach({ $0.update() })
    }

    func sendGameState() {
        let renderSystemPath = FirebasePaths.games + "/" + room.gameID + "/" + "RenderSystem"
        let renderSystemData = RenderSystemData(from: renderSystem)
        connectionHandler.send(
            to: renderSystemPath,
            data: renderSystemData,
            mode: .single,
            shouldRemoveOnDisconnect: false,
            onComplete: nil,
            onError: nil
        )

        let animSystemPath = FirebasePaths.games + "/" + room.gameID + "/" + "AnimSystem"
        let animationSystemData = AnimationSystemData(from: animationSystem)
        connectionHandler.send(
            to: animSystemPath,
            data: animationSystemData,
            mode: .single,
            shouldRemoveOnDisconnect: false,
            onComplete: nil,
            onError: nil
        )

        var colorables = [GameEntity: Colorable]()
        entities.forEach({ entity in
            if let colorable = entity as? Colorable {
                colorables[entity] = colorable
            }
        })

        let colorSystemPath = FirebasePaths.games + "/" + room.gameID + "/" + "ColorSystem"
        let colorSystemData = ColorSystemData(from: colorables)
        connectionHandler.send(
            to: colorSystemPath,
            data: colorSystemData,
            mode: .single,
            shouldRemoveOnDisconnect: false,
            onComplete: nil,
            onError: nil
        )
    }

    deinit {
        print("deinit gamescene")
    }
}


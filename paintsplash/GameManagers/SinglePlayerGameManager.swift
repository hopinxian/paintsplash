//
//  SinglePlayerGameManager.swift
//  paintsplash
//
//  Created by Praveen Bala on 8/3/21.

import SpriteKit

class SinglePlayerGameManager: GameManager {
    weak var gameScene: GameScene?
    weak var viewController: GameViewController?

    // game entities that should change
    var entities = Set<GameEntity>()

    // game entities that are specific to player and do not change
    var uiEntities = Set<GameEntity>()

    var currentLevel: Level?

    var aiSystem: StateManagerSystem!
    var audioManager: AudioSystem! = AudioManager()
    var renderSystem: RenderSystem!
    var animationSystem: AnimationSystem!
    var collisionSystem: CollisionSystem!
    var movementSystem: MovementSystem! = FrameMovementSystem()
    var transformSystem: TransformSystem! = WorldTransformSystem()
    var playerSystem: PlayerSystem! = PaintSplashPlayerSystem()
    var userInputSystem: UserInputSystem! = SKUserInputSystem()

    private var collisionDetector: SKCollisionDetector!

    var player: Player!
    var gameInfoManager: GameInfoManager

    var gameIsOver = false

    private var inGameSystems: [System] {
        [transformSystem,
         renderSystem,
         aiSystem,
         collisionSystem,
         movementSystem,
         animationSystem,
         playerSystem]
    }

    private var allSystems: [System] {
        inGameSystems + [userInputSystem]
    }

    init(gameScene: GameScene, vc: GameViewController) {
        self.gameScene = gameScene
        self.viewController = vc
        let gameInfo = GameInfo(playerPosition: Vector2D.zero)
        self.gameInfoManager = GameInfoManager(gameInfo: gameInfo)

        setupEventListeners()
        setupGame()
    }

    private func setupEventListeners() {
        EventSystem.entityChangeEvents.addEntityEvent.subscribe(listener: { [weak self] event in
            self?.onAddEntity(event: event)
        })

        EventSystem.entityChangeEvents.removeEntityEvent.subscribe(listener: { [weak self] event in
            self?.onRemoveEntity(event: event)
        })

        EventSystem.entityChangeEvents.addUIEntityEvent.subscribe(listener: { [weak self] event in
            self?.onAddUIEntity(event: event)
        })

        EventSystem.entityChangeEvents.removeUIEntityEvent.subscribe(listener: { [weak self] event in
            self?.onRemoveUIEntity(event: event)
        })

        EventSystem.gameStateEvents.gameOverEvent.subscribe(listener: { [weak self] in
            self?.onGameOver(event: $0)
        })
    }

    func setupGame() {
        setUpSystems()
        setUpPlayer()
        setUpEntities()
        setUpUI()
        setUpAudio()
    }

    func setUpSystems() {
        guard let gameScene = self.gameScene else {
            fatalError("Failed to initialize gamescene")
        }

        let skRenderSystem = SKRenderSystem(scene: gameScene)
        self.renderSystem = skRenderSystem

        let skCollisionSystem = SKCollisionSystem(renderSystem: skRenderSystem)
        self.collisionSystem = skCollisionSystem

        self.collisionDetector = SKCollisionDetector(renderSystem: skRenderSystem, collisionSystem: skCollisionSystem)
        gameScene.physicsWorld.contactDelegate = collisionDetector

        self.animationSystem = SKAnimationSystem(renderSystem: skRenderSystem)

        self.aiSystem = GameStateManagerSystem(gameInfo: gameInfoManager.gameInfo)

//        self.audioManager = AudioManager()
//
//        self.movementSystem = FrameMovementSystem()
//
//        self.transformSystem = WorldTransformSystem()
//
//        self.playerSystem = PaintSplashPlayerSystem()
//
//        self.userInputSystem = SKUserInputSystem()

        gameScene.inputSystem = userInputSystem
    }

    func setUpPlayer() {
        player = Player(initialPosition: Vector2D.zero)
        player.spawn()
    }

    func setUpEntities() {
        let canvasSpawner = CanvasSpawner(canvasVelocity: Vector2D(0.4, 0), spawnInterval: 10)
        canvasSpawner.spawn()

        let canvasManager = CanvasRequestManager()
        canvasManager.spawn()

        let canvasEndMarker = CanvasEndMarker()
        canvasEndMarker.spawn()

        let mixingPot1 = MixingPot(position: Vector2D(-800, 0))
        mixingPot1.spawn()

        let mixingPot2 = MixingPot(position: Vector2D(800, 0))
        mixingPot2.spawn()

        currentLevel = Level.getDefaultLevel(canvasManager: canvasManager, gameInfo: gameInfoManager.gameInfo)
        currentLevel?.start()
    }

    func setUpAudio() {
        self.audioManager.associatedDevice = player.id
        self.audioManager.playAudio(Music.backgroundMusic)
    }

    func setUpUI() {
        let background = Background()
        background.spawn()

        guard let paintGun = player.multiWeaponComponent.weaponOfType(PaintGun.self) else {
            fatalError("PaintGun not setup properly")
        }

        let paintGunUI = PaintGunAmmoDisplay(
            weaponData: paintGun,
            associatedEntity: player.id
        )
        paintGunUI.spawn()
        paintGunUI.ammoDisplayView.animationComponent.animate(
            animation: WeaponAnimations.selectWeapon,
            interupt: true
        )

        guard let paintBucket = player.multiWeaponComponent.weaponOfType(Bucket.self) else {
            fatalError("PaintBucket not setup properly")
        }

        let paintBucketUI = PaintBucketAmmoDisplay(weaponData: paintBucket, associatedEntity: player.id)
        paintBucketUI.spawn()
        paintBucketUI.ammoDisplayView.animationComponent.animate(
            animation: WeaponAnimations.unselectWeapon,
            interupt: true
        )

        let joystick = MovementJoystick(associatedEntityID: player.id)
        joystick.spawn()

        let attackJoystick = AttackJoystick(associatedEntityID: player.id)
        attackJoystick.spawn()

        let playerHealthUI = PlayerHealthDisplay(
            startingHealth: player.healthComponent.currentHealth,
            associatedEntityId: player.id
        )
        playerHealthUI.spawn()

        let bottombar = BottomUIBar()
        bottombar.spawn()

        let topBar = TopUIBar()
        topBar.spawn()

        let scoreDisplay = ScoreDisplay()
        scoreDisplay.spawn()

        let lights = LightDisplay()
        lights.spawn()
    }

    func onAddEntity(event: AddEntityEvent) {
        addObject(event.entity)
    }

    func onRemoveEntity(event: RemoveEntityEvent) {
        removeObject(event.entity)
    }

    func onAddUIEntity(event: AddUIEntityEvent) {
        uiEntities.insert(event.entity)
        addObjectToSystems(event.entity)
    }

    func onRemoveUIEntity(event: RemoveUIEntityEvent) {
        uiEntities.remove(event.entity)
        removeObjectFromSystems(event.entity)
    }

    func addObjectToSystems(_ object: GameEntity) {
        allSystems.forEach { $0.addEntity(object) }
//        transformSystem.addEntity(object)
//        renderSystem.addEntity(object)
//        aiSystem.addEntity(object)
//        collisionSystem.addEntity(object)
//        movementSystem.addEntity(object)
//        animationSystem.addEntity(object)
//        playerSystem.addEntity(object)
//        userInputSystem.addEntity(object)
    }

    func removeObjectFromSystems(_ object: GameEntity) {
        allSystems.forEach { $0.removeEntity(object) }
//        transformSystem.removeEntity(object)
//        renderSystem.removeEntity(object)
//        aiSystem.removeEntity(object)
//        collisionSystem.removeEntity(object)
//        movementSystem.removeEntity(object)
//        animationSystem.removeEntity(object)
//        playerSystem.removeEntity(object)
//        userInputSystem.removeEntity(object)
    }

    func addObject(_ object: GameEntity) {
        entities.insert(object)
        addObjectToSystems(object)
    }

    func removeObject(_ object: GameEntity) {
        entities.remove(object)
        removeObjectFromSystems(object)
    }

    func update(_ deltaTime: Double) {
        if !gameIsOver || currentLevel == nil {
            currentLevel?.run(deltaTime)
//            transformSystem?.updateEntities(deltaTime)
//            aiSystem?.updateEntities(deltaTime)
//            renderSystem?.updateEntities(deltaTime)
//            animationSystem?.updateEntities(deltaTime)
//            collisionSystem?.updateEntities(deltaTime)
//            movementSystem?.updateEntities(deltaTime)
//            playerSystem?.updateEntities(deltaTime)
            inGameSystems.forEach { $0.updateEntities(deltaTime) }
            
            entities.forEach { $0.update(deltaTime) }
        }
        userInputSystem.updateEntities(deltaTime)
    }

    private func onGameOver(event: GameOverEvent) {
        gameIsOver = true
        let gameOverUI = GameOverUI(
            score: currentLevel?.score.score ?? event.score ?? 0,
            onQuit: { [weak self] in self?.onQuit() }
        )
        gameOverUI.spawn()

        EventSystem.audioEvent.stopAudioEvent.post(event: StopAudioEvent())
        let newMusic = event.isWin ? Music.gameOverWin : Music.gameOverLose
        EventSystem.audioEvent.playMusicEvent.post(event: PlayMusicEvent(music: newMusic))
    }

    private func onQuit() {
        viewController?.closeGame()
    }

    deinit {
        print("deinit SinglePlayerGameManager")
    }
}

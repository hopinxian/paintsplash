//
//  MultiplayerManager.swift
//  paintsplash
//
//  Created by Farrell Nah on 28/3/21.
//

import Foundation

// TODO: subclass single player game manager, override?
class MultiplayerServer: SinglePlayerGameManager {
    var room: RoomInfo
    var lobbyHandler: LobbyHandler
    var gameConnectionHandler: GameConnectionHandler?
    var gameId: String?

    var otherPlayer: Player!

//    var gameScene: GameScene
//    var gameManager: GameManager?
//    var entities = Set<GameEntity>() // shared entities
//    var uiEntities = Set<GameEntity>()

    // stuff that is not shared: health, ammo, joystick, shooting uibar, background

//    var currentLevel: Level?
//
//    var aiSystem: StateManagerSystem!
//    var audioManager: AudioSystem!
//    var renderSystem: RenderSystem!
//    var animationSystem: AnimationSystem!
//    var collisionSystem: CollisionSystem!
//    var movementSystem: MovementSystem!

    private var collisionDetector: SKCollisionDetector!

    init(lobbyHandler: LobbyHandler, roomInfo: RoomInfo, gameScene: GameScene) {
        self.lobbyHandler = lobbyHandler
        self.room = roomInfo
        self.gameId = roomInfo.gameId
        super.init(gameScene: gameScene)
    }

    override func setupGame() {
        setUpSystems()
//        setUpUI() // Static non changing stuff that shouldn't be synced (joystick, bg)

        self.gameConnectionHandler = FirebaseGameHandler()

        setUpEntities()
        setUpUI() // Static non changing stuff that shouldn't be synced (joystick, bg)
    }

//    func setUpSystems() {
//        let skRenderSystem = SKRenderSystem(scene: gameScene)
//        self.renderSystem = skRenderSystem
//
//        let skCollisionSystem = SKCollisionSystem(renderSystem: skRenderSystem)
//        self.collisionSystem = skCollisionSystem
//
//        self.collisionDetector = SKCollisionDetector(renderSystem: skRenderSystem, collisionSystem: skCollisionSystem)
//        gameScene.physicsWorld.contactDelegate = collisionDetector
//
//        self.animationSystem = SKAnimationSystem(renderSystem: skRenderSystem)
//
//        self.aiSystem = GameStateManagerSystem()
//
//        self.audioManager = AudioManager()
//
//        self.movementSystem = FrameMovementSystem()
//    }

    override func setUpEntities() {
        let background = Background()
        background.spawn()

//         TODO: handle 2 players

        guard let hostId = UUID(uuidString: room.host.playerUUID) else {
            fatalError("UUID host err")
        }
        player = Player(initialPosition: Vector2D.zero + Vector2D.right * 50, playerUUID: hostId)
        player.spawn()
        assert(player.id == hostId)

        EventSystem.playerActionEvent.playerHealthUpdateEvent.subscribe(listener: { event in
            guard event.playerId == hostId else {
                return
            }
            self.gameConnectionHandler?.sendPlayerState(gameId: self.gameId ?? "",
                                                        playerId: hostId.uuidString,
                                                        playerState: PlayerStateInfo(playerId: hostId,
                                                                                     health: event.newHealth))
        })

        guard let otherIdStr = room.players?.first?.value.playerUUID else {
            fatalError("Cannot get client uuid")
        }

        guard let otherId = UUID(uuidString: otherIdStr) else {
            fatalError("UUID client err")
        }

        otherPlayer = Player(initialPosition: Vector2D.zero + Vector2D.left * 50, playerUUID: otherId)
        otherPlayer.spawn()
        assert(otherPlayer.id == otherId)

        EventSystem.playerActionEvent.playerHealthUpdateEvent.subscribe(listener: { event in
            guard event.playerId == otherId else {
                return
            }
            self.gameConnectionHandler?.sendPlayerState(gameId: self.gameId ?? "",
                                                        playerId: otherIdStr,
                                                        playerState: PlayerStateInfo(playerId: otherId,
                                                                                     health: event.newHealth))
        })

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

    override func setUpUI() {
//        guard let paintGun = player.multiWeaponComponent.availableWeapons.compactMap({ $0 as? PaintGun }).first else {
//            fatalError("PaintGun not setup properly")
//        }
//
//        let paintGunUI = PaintGunAmmoDisplay(weaponData: paintGun)
//        paintGunUI.spawn()
//        paintGunUI.ammoDisplayView.animationComponent.animate(animation: WeaponAnimations.selectWeapon, interupt: true)
//
//        guard let paintBucket = player.multiWeaponComponent.availableWeapons.compactMap({ $0 as? Bucket }).first else {
//            fatalError("PaintBucket not setup properly")
//        }
//
//        let paintBucketUI = PaintBucketAmmoDisplay(weaponData: paintBucket)
//        paintBucketUI.spawn()
//        paintBucketUI.ammoDisplayView.animationComponent.animate(
//            animation: WeaponAnimations.unselectWeapon,
//            interupt: true
//        )

        let joystick = MovementJoystick(associatedEntityID: player.id, position: Constants.JOYSTICK_POSITION)
        joystick.spawn()

        let attackButton = AttackButton(associatedEntityID: player.id)
        attackButton.spawn()

        let playerHealthUI =
            PlayerHealthDisplay(startingHealth: player.healthComponent.currentHealth, associatedEntityId: player.id)
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

    func sendGameState() {

    }

    func receiveInput() {

    }

    private func onAddEntity(event: AddEntityEvent) {
        addObject(event.entity)
    }
//
//    func addObject(_ object: GameEntity) {
//        entities.insert(object)
//        renderSystem.addEntity(object)
//        aiSystem.addEntity(object)
//        collisionSystem.addEntity(object)
//        movementSystem.addEntity(object)
//        animationSystem.addEntity(object)
//
//        // TODO: adding child
//
//    }

    private func onRemoveEntity(event: RemoveEntityEvent) {
        removeObject(event.entity)
    }

//    func removeObject(_ object: GameEntity) {
//        entities.remove(object)
//        renderSystem.removeEntity(object)
//        aiSystem.removeEntity(object)
//        collisionSystem.removeEntity(object)
//        movementSystem.removeEntity(object)
//        animationSystem.removeEntity(object)
//
//        // remove child
//    }
//
//    func update() {
//        currentLevel?.update()
//        let entityList = Array(entities)
//        aiSystem.updateEntities()
//        renderSystem.updateEntities()
//        animationSystem.updateEntities()
//        collisionSystem.updateEntities()
//        movementSystem.updateEntities()
//        entityList.forEach({
//            $0.update()
//            // TODO update child
//        })
//    }

}

class MultiplayerClient: GameManager {
    var uiEntities = Set<GameEntity>()

    var entities = Set<GameEntity>()
    var room: RoomInfo
    var connectionHandler: ConnectionHandler
    var gameScene: GameScene
    var gameConnectionHandler = FirebaseGameHandler()

    var playerInfo: PlayerInfo

    var renderSystem: RenderSystem!
    var animationSystem: AnimationSystem!
    var audioSystem: AudioSystem!

    init(connectionHandler: ConnectionHandler, gameScene: GameScene, playerInfo: PlayerInfo, roomInfo: RoomInfo) {
        self.connectionHandler = connectionHandler
        self.gameScene = gameScene
        self.playerInfo = playerInfo
        self.room = roomInfo

        print("init client")
        EventSystem.entityChangeEvents.addEntityEvent.subscribe(listener: onAddEntity)
        EventSystem.entityChangeEvents.removeEntityEvent.subscribe(listener: onRemoveEntity)
        assert(playerInfo.playerUUID == room.players!.first!.value.playerUUID, "Wrong uuid")
        setupGame()
    }

    func setupGame() {
        setUpSystems()
        setUpEntities()
        setUpUI()
        setUpAudio()

        setUpObservers()
    }

    func setUpObservers() {
        guard let gameID = room.gameId else {
            return
        }
        gameConnectionHandler.observePlayerState(gameId: gameID,
                                                 playerId: playerInfo.playerUUID,
                                                 onChange: onPlayerStateChange )
    }

    func onPlayerStateChange(playerState: PlayerStateInfo) {
        print("CHANGED PLAYER STATE: \(playerState)")
    }

    func setUpSystems() {
        let renderSystem = SKRenderSystem(scene: gameScene)
        self.renderSystem = renderSystem
        animationSystem = SKAnimationSystem(renderSystem: renderSystem)
        audioSystem = AudioManager()
    }

    func setUpEntities() {

    }

    func setUpUI() {
        let background = Background()
        background.spawn()

//        add player id to button and joystick

//        let joystick = Joystick()
//        joystick.spawn()
//
//        let attackButton = AttackButton()
//        attackButton.spawn()

        // let playerHealthUI = PlayerHealthDisplay(startingHealth: player.healthComponent.currentHealth)

        // TODO: player health is currently hardcoded
        guard let playerId = UUID(uuidString: playerInfo.playerUUID) else {
            return
        }

        let playerHealthUI = PlayerHealthDisplay(startingHealth: 3, associatedEntityId: playerId)
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

        guard let gameId = room.gameId else {
            return
        }
        gameConnectionHandler.observePlayerState(gameId: gameId, playerId: playerInfo.playerUUID,
                                                 onChange: handlePlayerStateUpdate)
    }

    func handlePlayerStateUpdate(playerState: PlayerStateInfo) {
        guard playerState.playerId.uuidString == playerInfo.playerUUID else {
            return
        }
        let health = playerState.health
        EventSystem.playerActionEvent.playerHealthUpdateEvent.post(event: PlayerHealthUpdateEvent(newHealth: health,
                                                                                                  playerId: playerState.playerId))
    }

    func setUpAudio() {

    }

    func inLobby() -> Bool {
        false
    }

    func updateGameState() {

    }

    func sendInput(event: TouchInputEvent) {

    }

    func update() {
        let entityList = Array(entities)
        renderSystem.updateEntities()
        animationSystem.updateEntities()
        entityList.forEach({ $0.update() })
    }

    func addObject(_ object: GameEntity) {
        entities.insert(object)
        renderSystem.addEntity(object)
        animationSystem.addEntity(object)
    }

    private func onAddEntity(event: AddEntityEvent) {
        addObject(event.entity)
    }

    func removeObject(_ object: GameEntity) {
        entities.remove(object)
        renderSystem.removeEntity(object)
        animationSystem.removeEntity(object)
    }

    private func onRemoveEntity(event: RemoveEntityEvent) {
        removeObject(event.entity)
    }
}

enum MultiplayerError: Error {
    case alreadyInLobby
    case cannotJoinLobby
}

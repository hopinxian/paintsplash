//
//  MultiplayerManager.swift
//  paintsplash
//
//  Created by Farrell Nah on 28/3/21.
//

class MultiplayerServer: GameManager {
    var entities = Set<GameEntity>()
    var room: RoomInfo
    var lobbyHandler: LobbyHandler

    init(lobbyHandler: LobbyHandler, roomInfo: RoomInfo) {
        self.lobbyHandler = lobbyHandler
        self.room = roomInfo
    }

    func sendGameState() {

    }

    func receiveInput() {

    }

    func update() {

    }

    func addObject(_ object: GameEntity) {

    }

    func removeObject(_ object: GameEntity) {

    }
}

class MultiplayerClient: GameManager {
    var entities = Set<GameEntity>()
    var room: RoomInfo?
    var connectionHandler: ConnectionHandler
    var gameScene: GameScene

    var renderSystem: RenderSystem!
    var animationSystem: AnimationSystem!
    var audioSystem: AudioSystem!

    init(connectionHandler: ConnectionHandler, gameScene: GameScene) {
        self.connectionHandler = connectionHandler
        self.gameScene = gameScene
        setupGame()
    }

    func setupGame() {
        setUpSystems()
        setUpEntities()
        setUpUI()
        setUpAudio()
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

    }

    func setUpAudio() {

    }

    func inLobby() -> Bool {
        return false
    }

    func updateGameState() {

    }

    func sendInput(event: TouchInputEvent) {

    }

    func update() {

    }

    func addObject(_ object: GameEntity) {

    }

    func removeObject(_ object: GameEntity) {
        
    }
}

enum MultiplayerError: Error {
    case alreadyInLobby
    case cannotJoinLobby
}

//
//  GameManagerAISystem.swift
//  paintsplash
//
//  Created by Cynthia Lee on 14/3/21.
//
//
//class GameManagerAISystem: AISystem {
//    var AIEntities: Set<AIEntity> = []
//
//    var gameManager: GameManager
//
//    init(gameManager: GameManager) {
//        self.gameManager = gameManager
//
//        EventSystem.spawnAIEntityEvent.subscribe(listener: onSpawnAIEntity)
//        EventSystem.despawnAIEntityEvent.subscribe(listener: onDespawnAIEntity)
//    }
//
//    func updateAIEntities() {
//        AIEntities.forEach { entity in
//            entity.currentBehaviour.updateAI(aiEntity: entity,
//                                             aiGameInfo: AIGameInfo(playerPosition: gameManager.currentPlayerPosition,
//                                                                    numberOfEnemies: AIEntities.count))
//        }
//    }
//
//    func add(aiEntity: AIEntity) {
//        self.AIEntities.insert(aiEntity)
//
//        aiEntity.spawn(gameManager: gameManager)
//        aiEntity.delegate = self
//
//        aiEntity.delegate?.didEntityUpdateState(aiEntity: aiEntity)
//    }
//
//    func remove(aiEntity: AIEntity) {
//        self.AIEntities.remove(aiEntity)
//    }
//
//    func update(aiEntity: AIEntity) {
//
//    }
//
//    func addEnemy(at position: Vector2D, with color: PaintColor) {
//        let enemy = Enemy(initialPosition: position, initialVelocity: Vector2D.left, color: color)
//        self.add(aiEntity: enemy)
//    }
//
//    func addEnemySpawner(at position: Vector2D, with color: PaintColor) {
//        let enemySpawner = EnemySpawner(initialPosition: position, initialVelocity: .zero, color: color)
//        self.add(aiEntity: enemySpawner)
//    }
//
//    func addCanvas(at position: Vector2D, velocity: Vector2D, size: Vector2D, endX: Double) {
//        let canvas = Canvas(initialPosition: position, velocity: velocity, size: size, endX: endX)
//        self.add(aiEntity: canvas)
//    }
//
//    func addCanvasSpawner(at position: Vector2D, velocity: Vector2D, canvasSize: Vector2D,
//                          spawnInterval: Double, endX: Double) {
//        let canvasSpawner = CanvasSpawner(initialPosition: position, canvasVelocity: velocity,
//                                          canvasSize: canvasSize, spawnInterval: spawnInterval,
//                                          endX: endX)
//        self.add(aiEntity: canvasSpawner)
//    }
//
//    func onSpawnAIEntity(event: SpawnAIEntityEvent) {
//        switch event.spawnEntityType {
//        case let .enemy(location, color):
//            addEnemy(at: location, with: color)
//        case let .canvas(location, velocity, size, endX):
//            addCanvas(at: location, velocity: velocity, size: size, endX: endX)
//        case let .enemySpawner(location, color):
//            addEnemySpawner(at: location, with: color)
//        case let .canvasSpawner(location, velocity, size, spawnInterval, endX):
//            addCanvasSpawner(at: location, velocity: velocity, canvasSize: size,
//                             spawnInterval: spawnInterval, endX: endX)
//        }
//    }
//
//    func onDespawnAIEntity(event: DespawnAIEntityEvent) {
//        remove(aiEntity: event.entityToDespawn)
//        event.entityToDespawn.destroy(gameManager: gameManager)
//    }
//
//}
//
//extension GameManagerAISystem: AIEntityDelegate {
//    func didEntityUpdateState(aiEntity: AIEntity) {
//        if let newAnimation = aiEntity.getAnimationFromState() {
//            aiEntity.animate(animation: newAnimation, interupt: true)
//        }
//    }
//}

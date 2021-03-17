//
//  GameManagerAISystem.swift
//  paintsplash
//
//  Created by Cynthia Lee on 14/3/21.
//

class GameManagerAISystem: AISystem {
    var AIEntities: Set<AIEntity> = []

    var gameManager: GameManager

    init(gameManager: GameManager) {
        self.gameManager = gameManager

        EventSystem.spawnAIEntityEvent.subscribe(listener: onSpawnAIEntity)
        EventSystem.despawnAIEntityEvent.subscribe(listener: onDespawnAIEntity)
    }

    func updateAIEntities() {
        AIEntities.forEach { entity in
            entity.currentBehaviour.updateAI(aiEntity: entity,
                                             aiGameInfo: AIGameInfo(playerPosition: gameManager.currentPlayerPosition,
                                                                    numberOfEnemies: AIEntities.count))
        }
    }

    func add(aiEntity: AIEntity) {
        self.AIEntities.insert(aiEntity)

        aiEntity.spawn(gameManager: gameManager)
        aiEntity.delegate = self

        aiEntity.delegate?.didEntityUpdateState(aiEntity: aiEntity)
    }

    func remove(aiEntity: AIEntity) {
        // TODO: set fade duration
        aiEntity.fadeDestroy(gameManager: gameManager, duration: 1.0)
    }

    func update(aiEntity: AIEntity) {
        
    }

    func addEnemy(at position: Vector2D) {
        let enemy = Enemy(initialPosition: position, initialVelocity: Vector2D(-1, 0))
        self.add(aiEntity: enemy)
    }

    func addEnemySpawner(at position: Vector2D) {
        let enemySpawner = EnemySpawner(initialPosition: position, initialVelocity: .zero)
        self.add(aiEntity: enemySpawner)
    }

    func addCanvas(at position: Vector2D, velocity: Vector2D) {
        let canvas = Canvas(initialPosition: position, velocity: velocity)
        self.add(aiEntity: canvas)
    }

    func onSpawnAIEntity(event: SpawnAIEntityEvent) {
        switch event.spawnEntityType {
        case .enemy(let location):
            addEnemy(at: location)
        case .canvas(let location, let velocity):
            addCanvas(at: location, velocity: velocity)
        }
    }

    func onDespawnAIEntity(event: DespawnAIEntityEvent) {
        event.entityToDespawn.fadeDestroy(gameManager: self.gameManager, duration: 1)
    }

}

extension GameManagerAISystem: AIEntityDelegate {
    func didEntityMove(aiEntity: AIEntity) {
        //TODO
    }

    func didEntityUpdateState(aiEntity: AIEntity) {
        aiEntity.currentAnimation = aiEntity.getAnimationFromState()
        gameManager.getRenderSystem().updateRenderableAnimation(aiEntity)
    }

}

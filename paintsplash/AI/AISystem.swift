//
//  AISystem.swift
//  paintsplash
//
//  Created by Cynthia Lee on 14/3/21.
//
//protocol AISystem {
//
//}
//
//class NewAISystem: AISystem {
//    func updateAIEntities(_ entities: [AIComponent]) {
//        for data in entities {
//            updateAIEntity(data)
//        }
//    }
//
//    func updateAIEntity(_ data: AIComponent) {
//        data.behaviour.updateAI(aiEntity: data.entity, aiGameInfo: ?)
//    }
//}

protocol AIEntity: GameEntity {
    var aiComponent: AIComponent { get }
}

protocol AISystem: System {
    func add(_ entity: GameEntity)
    func remove(_ entity: GameEntity)
}

class GameAISystem: AISystem {
    var aiEntities = [GameEntity: AIEntity]()
    var aiGameInfo: AIGameInfo

    init() {
        self.aiGameInfo = AIGameInfo(
            playerPosition: Vector2D.zero,
            numberOfEnemies: 0
        )

        EventSystem.playerActionEvent.playerMovementEvent.subscribe(listener: onPlayerMove)
        // Subscribe to events that change aiGameInfo here
    }

    private func onPlayerMove(event: PlayerMovementEvent) {
        aiGameInfo.playerPosition = event.location
    }

    func add(_ entity: GameEntity) {
        guard let aiEntity = entity as? AIEntity else {
            return
        }

        aiEntities[entity] = aiEntity
    }

    func remove(_ entity: GameEntity) {
        aiEntities[entity] = nil
    }

    func updateEntity(_ entity: GameEntity) {
        guard let aiEntity = entity as? AIEntity else {
            return
        }
        
        let behaviour = aiEntity.aiComponent.currentState.getBehaviour(aiEntity: aiEntity)
        behaviour.updateAI(aiEntity: aiEntity, aiGameInfo: aiGameInfo)

        if let newState = aiEntity.aiComponent.currentState.getStateTransition(aiEntity: aiEntity) {
            aiEntity.aiComponent.currentState = newState
        }
    }
}


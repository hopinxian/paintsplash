//
//  GameAISystem.swift
//  paintsplash
//
//  Created by Farrell Nah on 26/3/21.
//

class GameStateManagerSystem: StateManagerSystem {
    var aiEntities = [GameEntity: StatefulEntity]()
    var gameInfo: GameInfo

    init(gameInfo: GameInfo) {
        self.gameInfo = gameInfo
    }

    func addEntity(_ entity: GameEntity) {
        guard let aiEntity = entity as? StatefulEntity else {
            return
        }

        aiEntities[entity] = aiEntity
    }

    func removeEntity(_ entity: GameEntity) {
        aiEntities[entity] = nil
    }

    func updateEntities(_ deltaTime: Double) {
        for (entity, aiEntity) in aiEntities {
            updateEntity(entity, aiEntity)
        }
    }

    func updateEntity(_ entity: GameEntity, _ aiEntity: StatefulEntity) {
        let aiComponent = aiEntity.stateComponent
        if let newState = aiComponent.getNextState() {
            aiComponent.currentState = newState
        } else {
            aiComponent.currentState.onStayState()
        }
        let behaviour = aiComponent.getCurrentBehaviour()
        behaviour.updateAI(aiEntity: aiEntity, aiGameInfo: gameInfo)
    }
}

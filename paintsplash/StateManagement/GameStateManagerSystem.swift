//
//  GameAISystem.swift
//  paintsplash
//
//  Created by Farrell Nah on 26/3/21.
//

/// An implementation of the StateManagerSystem protocol for PaintSplash.
class GameStateManagerSystem: StateManagerSystem {
    var statefulEntities = [EntityID: StatefulEntity]()
    var gameInfo: GameInfo

    init(gameInfo: GameInfo) {
        self.gameInfo = gameInfo
    }

    func addEntity(_ entity: GameEntity) {
        guard let statefulEntity = entity as? StatefulEntity else {
            return
        }

        statefulEntities[entity.id] = statefulEntity
    }

    func removeEntity(_ entity: GameEntity) {
        statefulEntities[entity.id] = nil
    }

    func updateEntities(_ deltaTime: Double) {
        for (entity, statefulEntity) in statefulEntities {
            updateEntity(entity, statefulEntity)
        }
    }

    func updateEntity(_ entity: EntityID, _ statefulEntity: StatefulEntity) {
        let stateComponent = statefulEntity.stateComponent

        updateEntityState(stateComponent)
        runStateBehaviour(statefulEntity, stateComponent)
    }

    private func updateEntityState(_ stateComponent: StateComponent) {
        if let newState = stateComponent.getNextState() {
            stateComponent.setState(newState)
        } else {
            stateComponent.currentState.onStayState()
        }
    }

    private func runStateBehaviour(_ statefulEntity: StatefulEntity, _ stateComponent: StateComponent) {
        let behaviour = stateComponent.getCurrentBehaviour()
        behaviour.run(statefulEntity: statefulEntity, gameInfo: gameInfo)
    }
}

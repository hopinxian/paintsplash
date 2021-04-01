//
//  NetworkSystem.swift
//  paintsplash
//
//  Created by Farrell Nah on 1/4/21.
//

protocol NetworkSystem: System {
    var networkSources: [EntityID: NetworkSource] { get set }
}

class FirebaseNetworkSystem: NetworkSystem {
    var networkSources = [EntityID : NetworkSource]()

    func addEntity(_ entity: GameEntity) {
        guard let networkSource = entity as? NetworkSource else {
            return
        }

        networkSources[entity.id] = networkSource
    }

    func removeEntity(_ entity: GameEntity) {
        networkSources[entity.id] = nil
    }

    func updateEntities() {
        networkSources.forEach({ updateEntity($0.value) })
    }

    private func updateEntity(_ networkSource: NetworkSource) {
        
    }
}

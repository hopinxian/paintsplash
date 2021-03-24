//
//  System.swift
//  paintsplash
//
//  Created by Farrell Nah on 22/3/21.
//

protocol System {
    func updateEntities(_ entities: [GameEntity])
    func updateEntity(_ entity: GameEntity)
}

extension System {
    func updateEntities(_ entities: [GameEntity]) {
        for entity in entities {
            updateEntity(entity)
        }
    }
}

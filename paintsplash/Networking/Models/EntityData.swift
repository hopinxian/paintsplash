//
//  EntityData.swift
//  paintsplash
//
//  Created by Farrell Nah on 3/4/21.
//

struct EntityData: Codable {
    let entities: [EntityID]

    init(from entities: [GameEntity]) {
        self.entities = entities.map({ $0.id })
    }
}

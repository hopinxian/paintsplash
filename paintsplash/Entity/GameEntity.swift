//
//  Entity.swift
//  paintsplash
//
//  Created by Farrell Nah on 10/3/21.
//
import Foundation

class GameEntity {
    var id: UUID = UUID()

    func spawn(gameManager: GameManager) {
        gameManager.addObject(self)
    }

    func destroy(gameManager: GameManager) {
        gameManager.removeObject(self)
    }

    func update(gameManager: GameManager) {
    }
}

extension GameEntity: Hashable {
    static func == (lhs: GameEntity, rhs: GameEntity) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

//
//  SKCollisionSystem.swift
//  paintsplash
//
//  Created by Farrell Nah on 26/3/21.
//

class SKCollisionSystem: CollisionSystem {
    var renderSystem: SKRenderSystem

    init(renderSystem: SKRenderSystem) {
        self.renderSystem = renderSystem
    }

    func updateEntity(_ entity: GameEntity) {}

    func addEntity(_ entity: GameEntity) {
        guard let data = entity as? Collidable else {
            return
        }

        let physicsBody = data.collisionComponent.colliderShape.getPhysicsBody()
        physicsBody.contactTestBitMask = data.collisionComponent.tags.getBitMask()

        let nodeEntityMap = renderSystem.getNodeEntityMap()

        if nodeEntityMap[data] == nil {
            renderSystem.addEntity(entity)
        }

        let node = nodeEntityMap[data]
        node?.physicsBody = physicsBody
    }

    func removeEntity(_ entity: GameEntity) {
        guard let data = entity as? Collidable else {
            return
        }

        let nodeEntityMap = renderSystem.getNodeEntityMap()
        if let node = nodeEntityMap[data] {
            node.physicsBody = nil
        }
    }

    func collisionBetweenEntity(first: Collidable, second: Collidable) {
        first.onCollide(with: second)
        second.onCollide(with: first)
    }

    func updateEntities() {}
}

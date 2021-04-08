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

        let collisionData = data.collisionComponent
        let physicsBody = collisionData.colliderShape.getPhysicsBody()
        physicsBody.contactTestBitMask = collisionData.tags.getBitMask()

        let nodeEntityMap = renderSystem.getNodeEntityMap()

        if nodeEntityMap[data.id] == nil {
            renderSystem.addEntity(entity)
        }

        let node = nodeEntityMap[data.id]
        node?.physicsBody = physicsBody
    }

    func removeEntity(_ entity: GameEntity) {
        guard let data = entity as? Collidable else {
            return
        }

        let nodeEntityMap = renderSystem.getNodeEntityMap()
        if let node = nodeEntityMap[data.id] {
            node.physicsBody = nil
        }
    }

    func collisionBetweenEntity(first: Collidable, second: Collidable) {
        first.collisionComponent.onCollide(with: second)
        second.collisionComponent.onCollide(with: first)
    }

    func updateEntities(_ deltaTime: Double) {}
}

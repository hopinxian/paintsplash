//
//  Entity.swift
//  paintsplash
//
//  Created by Farrell Nah on 10/3/21.
//
import Foundation

class GameEntity {
    var id: UUID = UUID()

//    func spawn(renderSystem: RenderSystem, collisionSystem: CollisionSystem)
//    func destroy(renderSystem: RenderSystem, collisionSystem: CollisionSystem)
    func spawn(gameManager: GameManager) {
        gameManager.addObject(self)
    }
    func destroy(gameManager: GameManager) {
        gameManager.removeObject(self)
    }
    func update(gameManager: GameManager) {
//        print("Updating object \(id)")
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

class InteractiveEntity: GameEntity, Renderable, Collidable {
    var spriteName: String
    var currentAnimation: Animation?

    var colliderShape: ColliderShape

    var tags: Tags

    func onCollide(otherObject: Collidable, gameManager: GameManager) {

    }

    var transform: Transform

    init(spriteName: String, colliderShape: ColliderShape, tags: Tag..., transform: Transform) {
        self.spriteName = spriteName
        self.colliderShape = colliderShape
        self.tags = Tags(Set(tags))
        self.transform = transform
    }

    override func spawn(gameManager: GameManager) {
        super.spawn(gameManager: gameManager)
        gameManager.getRenderSystem().addRenderable(self)
        gameManager.getCollisionSystem().addCollidable(self)
    }

    override func destroy(gameManager: GameManager) {
        super.destroy(gameManager: gameManager)
        gameManager.getRenderSystem().removeRenderable(self)
        gameManager.getCollisionSystem().removeCollidable(self)
    }

    override func update(gameManager: GameManager) {
        super.update(gameManager: gameManager)
        gameManager.getRenderSystem().updateRenderable(renderable: self)
    }
}

//extension GameEntity where Self: Renderable & Collidable {
////    func spawn(renderSystem: RenderSystem, collisionSystem: CollisionSystem) {
////        renderSystem.addRenderable(self)
////        collisionSystem.addCollidable(self)
////    }
////
////    func destroy(renderSystem: RenderSystem, collisionSystem: CollisionSystem) {
////        renderSystem.removeRenderable(self)
////        collisionSystem.removeCollidable(self)
////    }
//
//    func spawn(gameManager: GameManager) {
//        gameManager.getRenderSystem().addRenderable(self)
//        gameManager.getCollisionSystem().addCollidable(self)
//    }
//
//    func destroy(gameManager: GameManager) {
//        gameManager.getRenderSystem().removeRenderable(self)
//        gameManager.getCollisionSystem().removeCollidable(self)
//    }
//}

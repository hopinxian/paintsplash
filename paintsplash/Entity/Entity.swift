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
    var currentAnimation: Animation? {
        didSet {
            guard let new = currentAnimation,
                  let old = oldValue,
                  !new.equal(to: old) else {
                return
            }

            let event = ChangeViewEvent(changeViewEventType: .changeAnimation(renderable: self))
            EventSystem.changeViewEvent.post(event: event)
        }
    }

    private var animationHasChanged = false
    var zPosition: Int = 0

    var colliderShape: ColliderShape

    var tags: Tags

    var renderColor: PaintColor? {
        return nil
    }
    
    func onCollide(otherObject: Collidable, gameManager: GameManager) {

    }

    var transform: Transform

    init(spriteName: String, colliderShape: ColliderShape, tags: Tag..., transform: Transform) {
        self.spriteName = spriteName
        self.colliderShape = colliderShape
        self.tags = Tags(Set(tags))
        self.transform = transform
        super.init()
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
        gameManager.getRenderSystem().updateRenderable(self)
    }

    func fadeDestroy(gameManager: GameManager, duration: Double) {
        super.destroy(gameManager: gameManager)
        gameManager.getRenderSystem().fadeRemoveRenderable(self, duration: duration)
        gameManager.getCollisionSystem().removeCollidable(self)
    }
}

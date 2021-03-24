////
////  InteractiveEntity.swift
////  paintsplash
////
////  Created by Ho Pin Xian on 16/3/21.
////
//
//class InteractiveEntity: GameEntity, Collidable {
//    var renderType: RenderType
//
//    private var animationHasChanged = false
//    var zPosition: Int = Constants.ZPOSITION_PLAYER
//
//    var colliderShape: ColliderShape
//
//    var tags: Tags
//
//    func onCollide(otherObject: Collidable) {
//
//    }
//
//    var transform: Transform
//
//    init(spriteName: String, colliderShape: ColliderShape, tags: [Tag], transform: Transform) {
//        renderType = RenderType.animation(spriteName: spriteName, defaultAnimation: nil)
//        self.colliderShape = colliderShape
//        self.tags = Tags(Set(tags))
//        self.transform = transform
//        super.init()
//    }
//
//    override func spawn(gameManager: GameManager) {
//        super.spawn(gameManager: gameManager)
//        gameManager.getRenderSystem().addRenderable(self)
//        gameManager.getCollisionSystem().addCollidable(self)
//    }
//
//    override func destroy(gameManager: GameManager) {
//        super.destroy(gameManager: gameManager)
//        gameManager.getRenderSystem().removeRenderable(self)
//        gameManager.getCollisionSystem().removeCollidable(self)
//    }
//
//    override func update(gameManager: GameManager) {
//        super.update(gameManager: gameManager)
//        gameManager.getRenderSystem().updateRenderable(self)
//    }
//}

//
//  HeartDisplay.swift
//  paintsplash
//
//  Created by Farrell Nah on 19/3/21.
//

class HeartDisplay: GameEntity, Renderable {
    var spriteName: String

    var defaultAnimation: Animation?

    var transform: Transform

    var zPosition: Int

    init(position: Vector2D, zPosition: Int) {
        self.zPosition = Constants.ZPOSITION_UI_ELEMENT
        spriteName = "heart"
        defaultAnimation = nil
        transform = Transform(position: position, rotation: 0.0, size: Vector2D(50, 50))
        super.init()
    }

    override func spawn(gameManager: GameManager) {
        gameManager.getRenderSystem().addRenderable(self)
        super.spawn(gameManager: gameManager)
    }

    override func destroy(gameManager: GameManager) {
        gameManager.getRenderSystem().removeRenderable(self)
        super.destroy(gameManager: gameManager)
    }

    override func update(gameManager: GameManager) {
        gameManager.getRenderSystem().updateRenderable(self)
        super.spawn(gameManager: gameManager)
    }
}

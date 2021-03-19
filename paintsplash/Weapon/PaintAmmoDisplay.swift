//
//  PaintAmmoDisplay.swift
//  paintsplash
//
//  Created by Farrell Nah on 16/3/21.
//

class PaintAmmoDisplay: GameEntity, Renderable, Colorable {
    var color: PaintColor

    var spriteName: String

    var defaultAnimation: Animation?

    var transform: Transform

    var zPosition: Int
    
    init(paintAmmo: PaintAmmo, position: Vector2D, zPosition: Int) {
        self.color = paintAmmo.color
        self.zPosition = zPosition
        spriteName = "WhiteSquare"
        defaultAnimation = nil
        transform = Transform(position: position, rotation: 0.0, size: Vector2D(50, 25))
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

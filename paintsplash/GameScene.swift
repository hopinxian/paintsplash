//
//  GameScene.swift
//  paintsplash
//
//  Created by Praveen Bala on 8/3/21.
//

import SpriteKit

class GameScene: SKScene {
    var gameManager: GameManager!

    override func didMove(to view: SKView) {
        isAccessibilityElement = false
        view.isMultipleTouchEnabled = true

        SpaceConverter.modelSize = Constants.MODEL_WORLD_SIZE
        SpaceConverter.screenSize = Vector2D(self.size.width, self.size.height)
    }

    override func update(_ currentTime: TimeInterval) {
        gameManager.update()
    }

    deinit {
        print("deinit gamescene")
    }
}

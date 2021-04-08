//
//  GameScene.swift
//  paintsplash
//
//  Created by Praveen Bala on 8/3/21.
//

import SpriteKit

class GameScene: SKScene {
    var gameManager: GameManager!

    var lastUpdateTime: TimeInterval = 0

    override func didMove(to view: SKView) {
        isAccessibilityElement = false

        SpaceConverter.modelSize = Constants.MODEL_WORLD_SIZE
        SpaceConverter.screenSize = Vector2D(self.size.width, self.size.height)
    }

    override func update(_ currentTime: TimeInterval) {
        let deltaTime = currentTime - lastUpdateTime
        lastUpdateTime = currentTime
        gameManager.update(deltaTime)
    }

    deinit {
        print("deinit gamescene")
    }
}

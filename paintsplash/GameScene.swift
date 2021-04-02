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
        // Get label node from scene and store it for use later
        isAccessibilityElement = false

        SpaceConverter.modelSize = Constants.MODEL_WORLD_SIZE
        SpaceConverter.screenSize = Vector2D(self.size.width, self.size.height)

        let testNode = SKShapeNode(circleOfRadius: 100)
        testNode.zPosition = 300
        let testChild = SKShapeNode(circleOfRadius: 50)
        testChild.zPosition = 300

        testNode.position = CGPoint(x: 300, y: 300)
        testChild.position = CGPoint(x: -100, y: -100)
        testNode.addChild(testChild)
        self.addChild(testNode)
    }

    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        gameManager.update()
    }

    deinit {
        print("deinit gamescene")
    }
}

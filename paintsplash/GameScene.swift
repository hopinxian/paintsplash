//
//  GameScene.swift
//  paintsplash
//
//  Created by Praveen Bala on 8/3/21.
//

import SpriteKit

class GameScene: SKScene {
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    private var enemies: Set<Enemy> = []

    private var circle1: TestCircle?
    private var ammoDrop: PaintAmmoDrop?

    var spaceConverter: SpaceConverter!
    var gameManager: GameManager!

    var nodes = [UUID : SKNode]()
    var bodies = [UUID: SKPhysicsBody]()
    var collidables = [SKPhysicsBody: Collidable]()

    override func didMove(to view: SKView) {
        // Get label node from scene and store it for use later
        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
        if let label = self.label {
            label.alpha = 0.0
            // label.run(SKAction.fadeIn(withDuration: 2.0))
        }

        physicsWorld.contactDelegate = self

        let w = (self.size.width + self.size.height) * 0.05

        spaceConverter = SpaceConverter(modelSize: Vector2D(2000, 2000), screenSize: Vector2D(UIScreen.main.bounds.maxX, UIScreen.main.bounds.maxY))

        EventSystem.changeViewEvent.subscribe(listener: onChangeViewEvent)
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered

        gameManager?.update()
    }
}

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

    var gameManager: GameManager!

    var nodes = [UUID : SKNode]()
    var bodies = [UUID: SKPhysicsBody]()
    var collidables = [SKPhysicsBody: Collidable]()

    override func didMove(to view: SKView) {
        // Get label node from scene and store it for use later
        SpaceConverter.modelSize = Vector2D(2000, 2000)
        SpaceConverter.screenSize = Vector2D(self.size.width, self.size.height)
        physicsWorld.contactDelegate = self

        let background = SKSpriteNode(imageNamed: "background")
        background.zPosition = CGFloat(Constants.ZPOSITION_FLOOR)
        background.size = SpaceConverter.modelToScreen(Vector2D(2000, 2000))

        self.addChild(background)
        
//        currentLevel = Level.defaultLevel
//        currentLevel?.run()


        EventSystem.changeViewEvent.subscribe(listener: onChangeViewEvent)
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered

        gameManager?.update()
    }
}

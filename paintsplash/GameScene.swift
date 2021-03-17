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

    var logicalToDisplayViewAdapter: LogicalToDisplayViewAdapter!

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

        // circle1.spawn(renderSystem: self, collisionSystem: self)
        // circle2.spawn(renderSystem: self, collisionSystem: self)

        // Create shape node to use during mouse interaction
        let w = (self.size.width + self.size.height) * 0.05
        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)

        if let spinnyNode = self.spinnyNode {
            spinnyNode.lineWidth = 2.5

            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
                                              SKAction.fadeOut(withDuration: 0.5),
                                              SKAction.removeFromParent()]))
        }

        logicalToDisplayViewAdapter = LogicalToDisplayViewAdapter(modelSize: Vector2D(2000, 2000), screenSize: Vector2D(UIScreen.main.bounds.maxX, UIScreen.main.bounds.maxY))

//        let joystick = JoystickMovement()

//        joystick.position = CGPoint(x: self.size.width / -2 + 100, y: -200)
//
//        joystick.setHandler(for: .moving) { displacement in
//            self.gameManager.currentPlayerVelocity = displacement.unitVector
//        }
//
//        joystick.setHandler(for: .end) { _ in
//            self.gameManager.currentPlayerVelocity = Vector2D.zero
//        }
//
//        addChild(joystick)
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered

        gameManager?.update()
    }
}

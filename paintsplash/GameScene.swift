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
    private var circle1: TestCircle = TestCircle(initialPosition: Vector2D(-250, 0), initialVelocity: Vector2D(1, 0))
    private var circle2: TestCircle = TestCircle(initialPosition: Vector2D(250, 0), initialVelocity: Vector2D(-1, 0))

    var nodes = [UUID : SKNode]()
    var bodies = [UUID: SKPhysicsBody]()
    var collidables = [SKPhysicsBody: Collidable]()

    override func didMove(to view: SKView) {        
        // Get label node from scene and store it for use later
        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
        if let label = self.label {
            label.alpha = 0.0
            label.run(SKAction.fadeIn(withDuration: 2.0))
        }

        physicsWorld.contactDelegate = self

        circle1.spawn(renderSystem: self, collisionSystem: self)
        circle2.spawn(renderSystem: self, collisionSystem: self)

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
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.green
            self.addChild(n)
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.blue
            self.addChild(n)
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.red
            self.addChild(n)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let label = self.label {
            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        }
        
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        circle1.move()
        circle2.move()

        updateRenderable(renderable: circle1)
        updateRenderable(renderable: circle2)


    }
}

extension GameScene: RenderSystem {
    func add(_ renderable: Renderable) {
        let skNode = SKSpriteNode(imageNamed: renderable.spriteName)

        skNode.position = CGPoint(renderable.transform.position)
        skNode.zRotation = CGFloat(renderable.transform.rotation)
//        skNode.size = CGSize(renderable.transform.scale)

        nodes[renderable.id] = skNode
        self.addChild(skNode)
    }

    func remove(_ renderable: Renderable) {
        guard let node = nodes[renderable.id] else {
            return
        }

        node.removeFromParent()
        nodes[renderable.id] = nil
    }

    func updateRenderable(renderable: Renderable) {
        let id = renderable.id
        guard let node = nodes[id] else {
            return
        }

        node.position = CGPoint(renderable.transform.position)
    }
}

extension GameScene: SKPhysicsContactDelegate, CollisionSystem {
    func didBegin(_ contact: SKPhysicsContact) {
        guard let bodyA = collidables[contact.bodyA],
              let bodyB = collidables[contact.bodyB] else {
            return
        }

        collisionBetween(first: bodyA, second: bodyB)
    }

    func add(collidable: Collidable) {
        if let node = nodes[collidable.id] {
            let physicsBody = collidable.colliderShape.getPhysicsBody()
            collidables[physicsBody] = collidable
            bodies[collidable.id] = physicsBody
            node.physicsBody = physicsBody
        } else {
            let skNode = SKSpriteNode()
            let physicsBody = collidable.colliderShape.getPhysicsBody()
            skNode.physicsBody = physicsBody

            collidables[physicsBody] = collidable
            bodies[collidable.id] = physicsBody
            nodes[collidable.id] = skNode
        }
    }

    func remove(collidable: Collidable) {
        if let node = nodes[collidable.id] {
            node.physicsBody = nil
        }

        bodies[collidable.id] = nil
    }

    func collisionBetween(first: Collidable, second: Collidable) {
        first.onCollide(otherObject: second)
        second.onCollide(otherObject: first)
    }
}

enum ColliderShape {
    case circle(radius: Double)

    func getPhysicsBody() -> SKPhysicsBody {
        switch self {
        case .circle(let radius):
            let physicsBody = SKPhysicsBody(circleOfRadius: CGFloat(radius))
            physicsBody.affectedByGravity = false
            physicsBody.contactTestBitMask = 0b0001
            return physicsBody
        default:
            return SKPhysicsBody()
        }
    }
}

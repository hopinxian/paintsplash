//
//  ColliderShape.swift
//  paintsplash
//
//  Created by Farrell Nah on 10/3/21.
//
import SpriteKit

enum ColliderShape {
    case circle(radius: Double)
    case enemy(radius: Double)
    case rectangle(size: Vector2D)
    case texture(name: String, size: Vector2D)

    func getPhysicsBody() -> SKPhysicsBody {
        var physicsBody = SKPhysicsBody()
        switch self {
        case .circle(let radius):
            physicsBody = SKPhysicsBody(circleOfRadius: CGFloat(radius))
        case .rectangle(let size):
            physicsBody = SKPhysicsBody(rectangleOf: CGSize(size))
        case .texture(let name, let size):
            physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: name), size: CGSize(size))
        case .enemy(let radius):
            let physicsBody = SKPhysicsBody(circleOfRadius: CGFloat(radius))
            physicsBody.affectedByGravity = false
            physicsBody.categoryBitMask = 0b0001
        default:
            return SKPhysicsBody()
        }

        physicsBody.affectedByGravity = false
        physicsBody.collisionBitMask = 0b0000
        return physicsBody
    }
}

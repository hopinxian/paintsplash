//
//  ColliderShape.swift
//  paintsplash
//
//  Created by Farrell Nah on 10/3/21.
//
import SpriteKit

enum ColliderShape {
    case circle(radius: Double)
    case texture(name: String)
    case enemy(radius: Double)

    func getPhysicsBody() -> SKPhysicsBody {
        switch self {
        case .circle(let radius):
            let physicsBody = SKPhysicsBody(circleOfRadius: CGFloat(radius))
            physicsBody.affectedByGravity = false
            physicsBody.contactTestBitMask = 0b0001
            return physicsBody
        case .enemy(let radius):
            let physicsBody = SKPhysicsBody(circleOfRadius: CGFloat(radius))
            physicsBody.affectedByGravity = false
            physicsBody.contactTestBitMask = 0b0010
            return physicsBody
        default:
            return SKPhysicsBody()
        }
    }
}

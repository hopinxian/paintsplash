//
//  CollisionSystem.swift
//  paintsplash
//
//  Created by Farrell Nah on 10/3/21.
//
import SpriteKit

protocol CollisionSystem: System {
    func collisionBetweenEntity(first: Collidable, second: Collidable)
}

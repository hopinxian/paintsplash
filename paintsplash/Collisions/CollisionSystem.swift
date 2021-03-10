//
//  CollisionSystem.swift
//  paintsplash
//
//  Created by Farrell Nah on 10/3/21.
//

protocol CollisionSystem {
    func add(collidable: Collidable)
    func remove(collidable: Collidable)
    func collisionBetween(first: Collidable, second: Collidable)
}

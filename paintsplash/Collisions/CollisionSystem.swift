//
//  CollisionSystem.swift
//  paintsplash
//
//  Created by Farrell Nah on 10/3/21.
//

protocol CollisionSystem {
    func addCollidable(_ collidable: Collidable)
    func removeCollidable(_ collidable: Collidable)
    func collisionBetween(first: Collidable, second: Collidable)
}

//
//  Collidable.swift
//  paintsplash
//
//  Created by Farrell Nah on 9/3/21.
//

protocol Collidable: GameEntity {
    var collisionComponent: CollisionComponent { get }
}

//
//  Movable.swift
//  paintsplash
//
//  Created by Praveen Bala on 8/3/21.
//

protocol Movable: GameEntity {
    var transformComponent: TransformComponent { get }
    var moveableComponent: MoveableComponent { get }
}

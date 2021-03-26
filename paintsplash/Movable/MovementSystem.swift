//
//  MovementSystem.swift
//  paintsplash
//
//  Created by Farrell Nah on 23/3/21.
//

protocol MovementSystem: System {
    var moveables: [GameEntity: Movable] { get set }
}

//
//  Renderable.swift
//  paintsplash
//
//  Created by Farrell Nah on 10/3/21.
//

protocol Renderable: GameEntity, Transformable {
    var spriteName: String { get }
}

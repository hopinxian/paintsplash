//
//  Renderable.swift
//  paintsplash
//
//  Created by Farrell Nah on 10/3/21.
//

protocol Renderable: Entity, Transformable {
    var spriteName: String { get }
}

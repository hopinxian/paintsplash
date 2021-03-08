//
//  Transformable.swift
//  paintsplash
//
//  Created by Praveen Bala on 8/3/21.
//

protocol Transformable {
    var position: Vector2D { get set }
    var rotation: Double { get set }
    var scale: Vector2D { get set }
}

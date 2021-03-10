//
//  Transformable.swift
//  paintsplash
//
//  Created by Praveen Bala on 8/3/21.
//

protocol Transformable: AnyObject {
    var transform: Transform { get set }

    func move(to position: Vector2D)

    func rotate(to angle: Double)

    func scale(to scale: Vector2D)

    func transform(to newTransform: Transform)
}

extension Transformable {
    func move(to newPosition: Vector2D) {
        transform.position = newPosition
    }

    func rotate(to newAngle: Double) {
        transform.rotation = newAngle
    }

    func scale(to newScale: Vector2D) {
        transform.scale = newScale
    }

    func transform(to newTransform: Transform) {
        transform = newTransform
    }
}

struct Transform {
    var position: Vector2D
    var rotation: Double
    var scale: Vector2D

    static let identity = Transform(position: Vector2D.zero, rotation: 0.0, scale: Vector2D(1, 1))
}

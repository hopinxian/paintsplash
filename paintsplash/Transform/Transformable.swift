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

    func scale(to newSize: Vector2D) {
        transform.size = newSize
    }

    func transform(to newTransform: Transform) {
        transform = newTransform
    }
}

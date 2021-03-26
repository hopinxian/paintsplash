//
//  BoundedTransformComponent.swift
//  paintsplash
//
//  Created by Farrell Nah on 26/3/21.
//

class BoundedTransformComponent: TransformComponent {
    override var position: Vector2D {
        didSet {
            if !bounds.inset(by: size / 2).contains(position) {
                position = oldValue
            }
        }
    }

    var bounds: Rect

    init(position: Vector2D, rotation: Double, size: Vector2D, bounds: Rect) {
        self.bounds = bounds
        super.init(position: position, rotation: rotation, size: size)
    }
}

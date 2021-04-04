//
//  TransformComponent.swift
//  paintsplash
//
//  Created by Farrell Nah on 26/3/21.
//
import Foundation

class TransformComponent: Component, Codable {
    var parentID: EntityID? {
        didSet {
            wasModified = true
        }
    }

    var localPosition: Vector2D {
        didSet {
            if (localPosition - oldValue).magnitude > 50 {
                wasModified = true
            }
        }
    }

    var rotation: Double {
        didSet {
            wasModified = true
        }
    }

    var size: Vector2D {
        didSet {
            wasModified = true
        }
    }

    var worldPosition: Vector2D {
        didSet {
            wasModified = true
        }
    }

    init(position: Vector2D, rotation: Double, size: Vector2D) {
        self.localPosition = position
        self.rotation = rotation
        self.size = size
        self.parentID = nil
        self.worldPosition = position
    }

    func addParent(_ parent: GameEntity) {
        guard let parentTransformable = parent as? Transformable else {
            return
        }

        self.parentID = parent.id
        self.worldPosition = parentTransformable.transformComponent.worldPosition + localPosition
    }

    func removeParent() {
        parentID = nil
    }
}

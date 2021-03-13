//
//  AmmoDrop.swift
//  paintsplash
//
//  Created by Farrell Nah on 12/3/21.
//
import Foundation

class PaintAmmoDrop: Renderable, Collidable {
    var id: UUID = UUID()

    var transform: Transform

    var spriteName: String = "BlueCircle"

    var colliderShape: ColliderShape
    var tags = Tags(tags: .ammoDrop)

    let size: Vector2D = Vector2D(50, 50)

    init(color: PaintColor, position: Vector2D) {
        self.transform = Transform(position: position, rotation: 0.0, scale: size)
        self.colliderShape = .rectangle(size: size)
    }

    func onCollide(otherObject: Collidable) {
        print("AmmoDrop Collide")
        if otherObject.tags.contains(.player) {
            print("Player Collected Ammo")
        }
    }
}

//
//  AmmoDrop.swift
//  paintsplash
//
//  Created by Farrell Nah on 12/3/21.
//
import Foundation

class PaintAmmoDrop: InteractiveEntity, AmmoDrop, Colorable {
    let size: Vector2D = Vector2D(50, 50)
    let color: PaintColor

    init(color: PaintColor, position: Vector2D) {
        self.color = color
        
        let transform = Transform(position: position, rotation: 0.0, scale: size)
        super.init(spriteName: "AmmoDrop", colliderShape: .rectangle(size: size), tags: .ammoDrop, transform: transform)
    }

    override func onCollide(otherObject: Collidable, gameManager: GameManager) {
        if otherObject.tags.contains(.player) {
            print("Player Collected Ammo")
            destroy(gameManager: gameManager)
        }
    }

    func getAmmoObject() -> PaintAmmo {
        PaintAmmo(color: color)
    }
}

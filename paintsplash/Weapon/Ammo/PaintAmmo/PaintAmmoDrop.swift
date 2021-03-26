//
//  AmmoDrop.swift
//  paintsplash
//
//  Created by Farrell Nah on 12/3/21.
//
import Foundation

class PaintAmmoDrop: GameEntity, Renderable, Collidable, AmmoDrop, Colorable {
    let transformComponent: TransformComponent
    let renderComponent: RenderComponent
    let collisionComponent: CollisionComponent

    let color: PaintColor

    init(color: PaintColor, position: Vector2D) {
        self.color = color
        self.transformComponent = TransformComponent(position: position, rotation: 0, size: Constants.AMMO_DROP_SIZE)
        self.renderComponent = RenderComponent(renderType: .sprite(spriteName: "AmmoDrop"), zPosition: Constants.ZPOSITION_AMMO_DROP)
        self.collisionComponent = CollisionComponent(colliderShape: .rectangle(size: Constants.AMMO_DROP_SIZE), tags: [.ammoDrop])

        super.init()
        
        addComponent(transformComponent)
        addComponent(renderComponent)
        addComponent(collisionComponent)
    }

    func onCollide(with: Collidable) {
        if with.collisionComponent.tags.contains(.player) {
            switch with {
            case let player as Player:
                if player.multiWeaponComponent.canLoad([getAmmoObject()]) {
                    EventSystem.entityChangeEvents.removeEntityEvent.post(event: RemoveEntityEvent(entity: self))
                }
            default:
                fatalError("Player does not conform to Player")
            }
        }
    }

    func getAmmoObject() -> Ammo {
        PaintAmmo(color: color)
    }
}

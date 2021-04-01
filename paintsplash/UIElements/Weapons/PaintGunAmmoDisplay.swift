//
//  WeaponAmmoDisplay.swift
//  paintsplash
//
//  Created by Farrell Nah on 16/3/21.
//
import Foundation

class PaintGunAmmoDisplay: UIEntity, Transformable {
    var transformComponent: TransformComponent

    var ammoDisplayView: VerticalStack<PaintAmmoDisplay>
    var weaponData: PaintGun
    let associatedEntity: EntityID

    init(weaponData: PaintGun, associatedEntity: EntityID) {
        self.associatedEntity = associatedEntity

        self.transformComponent = TransformComponent(
            position: Constants.PAINT_GUN_AMMO_DISPLAY_POSITION,
            rotation: 0.0,
            size: Constants.PAINT_GUN_AMMO_DISPLAY_SIZE
        )

        let displayView = VerticalStack<PaintAmmoDisplay>(
            position: transformComponent.localPosition,
            size: transformComponent.size,
            backgroundSprite: "WhiteSquare"
        )
        self.ammoDisplayView = displayView
        displayView.spawn()

        self.weaponData = weaponData
        super.init()

        updateAmmoDisplay(ammo: weaponData.getAmmo().compactMap({ $0 as? PaintAmmo }))

        EventSystem.playerActionEvent.playerAmmoUpdateEvent.subscribe(listener: onAmmoUpdate)
        EventSystem.playerActionEvent.playerChangedWeaponEvent.subscribe(listener: onChangeWeapon)
        EventSystem.inputEvents.touchDownEvent.subscribe(listener: touchDown)
    }

    private func onAmmoUpdate(event: PlayerAmmoUpdateEvent) {
        guard event.playerId == self.associatedEntity else {
            return
        }
        if event.weapon is PaintGun {
            updateAmmoDisplay(ammo: event.ammo.compactMap({ $0 as? PaintAmmo }))
        }
    }

    private func onChangeWeapon(event: PlayerChangedWeaponEvent) {
        guard event.playerId == self.associatedEntity else {
            return
        }
        if type(of: event.weapon) == type(of: weaponData) {
            ammoDisplayView.animationComponent.animate(animation: WeaponAnimations.selectWeapon, interupt: true)
        } else {
            ammoDisplayView.animationComponent.animate(animation: WeaponAnimations.unselectWeapon, interupt: true)
        }
    }

    private func updateAmmoDisplay(ammo: [PaintAmmo]) {
        let ammoDisplays = ammo
            .compactMap({ PaintAmmoDisplay(
                paintAmmo: $0,
                position: Vector2D.zero,
                zPosition: Constants.ZPOSITION_UI_ELEMENT + 1)
        })

        ammoDisplayView.changeItems(to: ammoDisplays)
    }

    func touchDown(event: TouchDownEvent) {
        let location = event.location
        if abs(transformComponent.localPosition.x - location.x) < transformComponent.size.x &&
            abs(transformComponent.localPosition.y - location.y) < transformComponent.size.y {
            let event = PlayerChangeWeaponEvent(newWeapon: PaintGun.self, playerId: associatedEntity)
            EventSystem.processedInputEvents.playerChangeWeaponEvent.post(event: event)
        }
    }
}

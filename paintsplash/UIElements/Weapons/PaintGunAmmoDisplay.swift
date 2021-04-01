//
//  WeaponAmmoDisplay.swift
//  paintsplash
//
//  Created by Farrell Nah on 16/3/21.
//

class PaintGunAmmoDisplay: UIEntity, Transformable {
    var transformComponent: TransformComponent

    var ammoDisplayView: VerticalStack<PaintAmmoDisplay>
    var weaponData: PaintGun

    init(weaponData: PaintGun) {
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

        EventSystem.entityChangeEvents.addEntityEvent.post(event: AddEntityEvent(entity: displayView))

        self.weaponData = weaponData
        super.init()

        updateAmmoDisplay(ammo: weaponData.getAmmo().compactMap({ $0 as? PaintAmmo }))

        EventSystem.playerActionEvent.playerAmmoUpdateEvent.subscribe(listener: onAmmoUpdate)
        EventSystem.playerActionEvent.playerChangedWeaponEvent.subscribe(listener: onChangeWeapon)
        EventSystem.inputEvents.touchDownEvent.subscribe(listener: touchDown)
    }

    private func onAmmoUpdate(event: PlayerAmmoUpdateEvent) {
        if event.weapon is PaintGun {
            updateAmmoDisplay(ammo: event.ammo.compactMap({ $0 as? PaintAmmo }))
        }
    }

    private func onChangeWeapon(event: PlayerChangedWeaponEvent) {
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
            let event = PlayerChangeWeaponEvent(newWeapon: PaintGun.self)
            EventSystem.processedInputEvents.playerChangeWeaponEvent.post(event: event)
        }
    }
}

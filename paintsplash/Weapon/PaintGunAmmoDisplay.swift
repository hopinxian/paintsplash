//
//  WeaponAmmoDisplay.swift
//  paintsplash
//
//  Created by Farrell Nah on 16/3/21.
//

class PaintGunAmmoDisplay: GameEntity, Transformable {
    var transform: Transform
    var ammoDisplayView: VerticalStackDisplay<PaintAmmoDisplay>
    var weaponData: PaintGun

    init(weaponData: PaintGun) {
        transform = Transform(
            position: Vector2D(300, -500),
            rotation: 0.0,
            size: Vector2D(60, 200)
        )
        let displayView = VerticalStackDisplay<PaintAmmoDisplay>(transform: transform, backgroundSprite: "WhiteSquare")
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
            ammoDisplayView.animate(animation: WeaponAnimations.selectWeapon, interupt: true)
        } else {
            ammoDisplayView.animate(animation: WeaponAnimations.unselectWeapon, interupt: true)
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
        if abs(transform.position.x - location.x) < transform.size.x &&
            abs(transform.position.y - location.y) < transform.size.y {
            let event = PlayerChangeWeaponEvent(newWeapon: PaintGun.self)
            EventSystem.processedInputEvents.playerChangeWeaponEvent.post(event: event)
        }
    }
}

//
//  PaintBucketAmmoDisplay.swift
//  paintsplash
//
//  Created by Farrell Nah on 17/3/21.
//

class PaintBucketAmmoDisplay: GameEntity, Transformable {
    var transformComponent: TransformComponent
    var ammoDisplayView: VerticalStack<PaintAmmoDisplay>
    var weaponData: Bucket

    init(weaponData: Bucket) {
        self.transformComponent = TransformComponent(position: Constants.PAINT_BUCKET_AMMO_DISPLAY_POSITION, rotation: 0.0, size: Constants.PAINT_BUCKET_AMMO_DISPLAY_SIZE)

        let displayView = VerticalStack<PaintAmmoDisplay>(
            position: transformComponent.position,
            size: transformComponent.size,
            backgroundSprite: "WhiteSquare"
        )

        self.ammoDisplayView = displayView
        EventSystem.entityChangeEvents.addEntityEvent.post(event: AddEntityEvent(entity: displayView))

        self.weaponData = weaponData

        super.init()

        addComponent(transformComponent)
        updateAmmoDisplay(ammo: weaponData.getAmmo().compactMap({ $0 as? PaintAmmo }))
        EventSystem.playerActionEvent.playerAmmoUpdateEvent.subscribe(listener: onAmmoUpdate)
        EventSystem.playerActionEvent.playerChangedWeaponEvent.subscribe(listener: onChangeWeapon)
        EventSystem.inputEvents.touchDownEvent.subscribe(listener: touchDown)
    }

    private func onAmmoUpdate(event: PlayerAmmoUpdateEvent) {
        if event.weapon is Bucket {
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
        if abs(transformComponent.position.x - location.x) < transformComponent.size.x &&
            abs(transformComponent.position.y - location.y) < transformComponent.size.y {
            let event = PlayerChangeWeaponEvent(newWeapon: Bucket.self)
            EventSystem.processedInputEvents.playerChangeWeaponEvent.post(event: event)
        }
    }
}

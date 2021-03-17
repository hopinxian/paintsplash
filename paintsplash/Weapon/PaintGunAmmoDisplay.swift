//
//  WeaponAmmoDisplay.swift
//  paintsplash
//
//  Created by Farrell Nah on 16/3/21.
//

class PaintGunAmmoDisplay: GameEntity, Renderable {
    var renderColor: PaintColor?

    var spriteName: String

    var currentAnimation: Animation?

    var transform: Transform

    var ammoDisplay = [PaintAmmoDisplay]()

    var weaponData: PaintGun

    init(weaponData: PaintGun) {
        renderColor = nil
        spriteName = "WhiteSquare"
        transform = Transform(
            position: Vector2D(300, -200),
            rotation: 0.0,
            size: Vector2D(60, 140)
        )
        self.weaponData = weaponData
        super.init()

        populate(with: weaponData.getAmmo())
        EventSystem.playerAmmoUpdateEvent.subscribe(listener: onAmmoUpdate)
    }

    private func onAmmoUpdate(event: PlayerAmmoUpdateEvent) {
        populate(with: event.ammo)
    }

    func populate(with ammo: [PaintAmmo]) {
        for display in ammoDisplay {
            EventSystem.removeEntityEvent.post(event: RemoveEntityEvent(entity: display))
        }

        ammoDisplay = []

        var nextPosition = transform.position - Vector2D(0, (transform.size.y / 2) - 22.5)
        for ammoData in ammo {
            let newDisplay = PaintAmmoDisplay(color: ammoData.color, position: nextPosition, zPosition: zPosition + 1)
            ammoDisplay.append(newDisplay)
            EventSystem.addEntityEvent.post(event: AddEntityEvent(entity: newDisplay))
            nextPosition += Vector2D(0, newDisplay.transform.size.y + 10)
        }

        print(ammoDisplay.count)
    }

    override func spawn(gameManager: GameManager) {
        gameManager.getRenderSystem().addRenderable(self)
        super.spawn(gameManager: gameManager)
    }

    override func destroy(gameManager: GameManager) {
        gameManager.getRenderSystem().removeRenderable(self)
        super.destroy(gameManager: gameManager)
    }

    override func update(gameManager: GameManager) {
        gameManager.getRenderSystem().updateRenderable(self)
        super.spawn(gameManager: gameManager)
    }
}

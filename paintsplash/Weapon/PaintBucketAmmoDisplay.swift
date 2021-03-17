//
//  PaintBucketAmmoDisplay.swift
//  paintsplash
//
//  Created by Farrell Nah on 17/3/21.
//

class PaintBucketAmmoDisplay: GameEntity, Renderable {
    var renderColor: PaintColor?

    var spriteName: String

    var currentAnimation: Animation?

    var transform: Transform

    var ammoDisplay = [PaintAmmoDisplay]()

    var weaponData: Bucket

    init(weaponData: Bucket) {
        renderColor = nil
        spriteName = "WhiteSquare"
        transform = Transform(
            position: Vector2D(300, -200),
            rotation: 0.0,
            size: Vector2D(60, 200)
        )
        self.weaponData = weaponData
        super.init()

        populate(with: weaponData.getAmmo().compactMap({ $0 as? PaintAmmo }))
        EventSystem.playerAmmoUpdateEvent.subscribe(listener: onAmmoUpdate)
    }

    private func onAmmoUpdate(event: PlayerAmmoUpdateEvent) {
        if event.weapon is Bucket {
            populate(with: event.ammo.compactMap({ $0 as? PaintAmmo }))
        }
    }

    func populate(with ammo: [PaintAmmo]) {
        for display in ammoDisplay {
            EventSystem.entityChangeEvents.removeEntityEvent.post(event: RemoveEntityEvent(entity: display))
        }

        ammoDisplay = []

        var nextPosition = transform.position - Vector2D(0, (transform.size.y / 2) - 70)
        for ammoData in ammo {
            let newDisplay = PaintAmmoDisplay(color: ammoData.color, position: nextPosition, zPosition: zPosition + 1)
            ammoDisplay.append(newDisplay)
            EventSystem.entityChangeEvents.addEntityEvent.post(event: AddEntityEvent(entity: newDisplay))
            nextPosition += Vector2D(0, newDisplay.transform.size.y + 1)
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


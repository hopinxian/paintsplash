//
//  PlayerHealthDisplay.swift
//  paintsplash
//
//  Created by Farrell Nah on 19/3/21.
//

class PlayerHealthDisplay: GameEntity, Renderable, Health {
    var currentHealth: Int = 5
    var maxHealth: Int = 5

    var spriteName: String

    var defaultAnimation: Animation?

    var transform: Transform

    var healthDisplay = [HeartDisplay]()

    init(startingHealth: Int, maxHealth: Int) {
        spriteName = "WhiteSquare"
        transform = Transform(
            position: Vector2D(-500, 500),
            rotation: 0.0,
            size: Vector2D(200, 60)
        )
        self.currentHealth = startingHealth
        self.maxHealth = maxHealth
        super.init()

        EventSystem.playerActionEvent.playerHealthUpdateEvent.subscribe(listener: onHealthUpdate)
        updateViews()
    }

    private func onHealthUpdate(event: PlayerHealthUpdateEvent) {
        let oldHealth = currentHealth
        currentHealth = event.newHealth
        if oldHealth > event.newHealth {
            heal(amount: event.newHealth - oldHealth)
        } else if oldHealth < event.newHealth {
            takeDamage(amount: oldHealth - event.newHealth)
        }
    }

    func updateViews() {
        for display in healthDisplay {
            EventSystem.entityChangeEvents.removeEntityEvent.post(event: RemoveEntityEvent(entity: display))
        }

        var nextPosition = transform.position - Vector2D((transform.size.x / 2) - 25, 0)
        for _ in 0..<currentHealth {
            let newDisplay = HeartDisplay(position: nextPosition, zPosition: zPosition + 1)
            healthDisplay.append(newDisplay)
            EventSystem.entityChangeEvents.addEntityEvent.post(event: AddEntityEvent(entity: newDisplay))
            nextPosition += Vector2D(newDisplay.transform.size.x + 25, 0)
        }
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

    func touchDown(event: TouchDownEvent) {
        let location = event.location

        if abs(transform.position.x - location.x) < transform.size.x &&
            abs(transform.position.y - location.y) < transform.size.y {
            let event = PlayerChangeWeaponEvent(newWeapon: PaintGun.self)
            EventSystem.processedInputEvents.playerChangeWeaponEvent.post(event: event)
        }
    }

    func heal(amount: Int) {
        updateViews()
    }

    func takeDamage(amount: Int) {
        updateViews()
    }
}

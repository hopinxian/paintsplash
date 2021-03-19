//
//  PlayerHealthDisplay.swift
//  paintsplash
//
//  Created by Farrell Nah on 19/3/21.
//

class PlayerHealthDisplay: GameEntity, Transformable {
    var transform: Transform
    var healthDisplayView: HorizontalStackDisplay<HeartDisplay>

    init(startingHealth: Int) {
        transform = Transform(
            position: Vector2D(-500, 500),
            rotation: 0.0,
            size: Vector2D(210, 60)
        )
        let displayView = HorizontalStackDisplay<HeartDisplay>(transform: transform, backgroundSprite: "WhiteSquare")
        self.healthDisplayView = displayView
        super.init()

        EventSystem.entityChangeEvents.addEntityEvent.post(event: AddEntityEvent(entity: displayView))
        EventSystem.playerActionEvent.playerHealthUpdateEvent.subscribe(listener: onHealthUpdate)
        updateViews(health: startingHealth)
    }

    private func onHealthUpdate(event: PlayerHealthUpdateEvent) {
        updateViews(health: event.newHealth)
    }

    private func updateViews(health: Int) {
        let healthDisplays = stride(from: 0, to: health, by: 1).map({ _ in HeartDisplay(position: Vector2D.zero, zPosition: 0) })
        healthDisplayView.changeItems(to: healthDisplays)
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

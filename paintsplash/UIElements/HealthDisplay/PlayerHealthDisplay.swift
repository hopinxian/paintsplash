//
//  PlayerHealthDisplay.swift
//  paintsplash
//
//  Created by Farrell Nah on 19/3/21.
//

class PlayerHealthDisplay: UIEntity, Transformable {
    let transformComponent: TransformComponent
    var healthDisplayView: HorizontalStack<HeartDisplay>

    init(startingHealth: Int) {
        self.transformComponent = TransformComponent(
            position: Constants.HEALTH_DISPLAY_POSITION,
            rotation: 0,
            size: Constants.HEALTH_DISPLAY_SIZE
        )

        let displayView = HorizontalStack<HeartDisplay>(
            position: transformComponent.position,
            size: transformComponent.size,
            backgroundSprite: "WhiteSquare"
        )

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
        let normalizedHealth = health >= 0 ? health : 0

        let healthDisplays = stride(from: 0, to: normalizedHealth, by: 1)
            .map { _ in
                HeartDisplay(position: Vector2D.zero, zPosition: Constants.ZPOSITION_UI_ELEMENT)
            }

        healthDisplayView.changeItems(to: healthDisplays)
    }
}

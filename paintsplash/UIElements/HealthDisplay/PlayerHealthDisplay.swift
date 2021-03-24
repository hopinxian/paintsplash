//
//  PlayerHealthDisplay.swift
//  paintsplash
//
//  Created by Farrell Nah on 19/3/21.
//

class PlayerHealthDisplay: GameEntity, Transformable {
    let transformComponent: TransformComponent
    var transform: Transform
    var healthDisplayView: HorizontalStack<HeartDisplay>

    init(startingHealth: Int) {
        transform = Transform(
            position: Constants.HEALTH_DISPLAY_POSITION,
            rotation: 0.0,
            size: Constants.HEALTH_DISPLAY_SIZE
        )
        self.transformComponent = TransformComponent(position: Constants.HEALTH_DISPLAY_POSITION, rotation: 0, size: Constants.HEALTH_DISPLAY_SIZE)

        let displayView = HorizontalStack<HeartDisplay>(
            position: transformComponent.position,
            size: transformComponent.size,
            backgroundSprite: "WhiteSquare"
        )

        self.healthDisplayView = displayView
        super.init()
        addComponent(transformComponent)
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

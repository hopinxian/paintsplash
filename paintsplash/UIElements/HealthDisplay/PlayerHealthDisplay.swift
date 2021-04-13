//
//  PlayerHealthDisplay.swift
//  paintsplash
//
//  Created by Farrell Nah on 19/3/21.
//

import Foundation

class PlayerHealthDisplay: UIEntity, Transformable {
    var transformComponent: TransformComponent
    var healthDisplayView: HorizontalStack<HeartDisplay>
    let associatedEntity: EntityID

    init(startingHealth: Int, associatedEntityId: EntityID) {
        self.transformComponent = TransformComponent(
            position: Constants.HEALTH_DISPLAY_POSITION,
            rotation: 0,
            size: Constants.HEALTH_DISPLAY_SIZE
        )

        let displayView = HorizontalStack<HeartDisplay>(
            position: transformComponent.localPosition,
            size: transformComponent.size,
            backgroundSprite: Constants.HEALTH_DISPLAY_SPRITE,
            zPosition: Constants.ZPOSITION_HEALTH_DISPLAY,
            seperation: 10,
            leftPadding: 55
        )

        self.healthDisplayView = displayView
        self.associatedEntity = associatedEntityId

        super.init()

        displayView.spawn()
        EventSystem.playerActionEvent
            .playerHealthUpdateEvent.subscribe(listener: { [weak self] in self?.onHealthUpdate(event: $0) })
        updateViews(health: startingHealth)
    }

    private func onHealthUpdate(event: PlayerHealthUpdateEvent) {
        guard event.playerId == associatedEntity else {
            return
        }
        updateViews(health: event.newHealth)
    }

    private func updateViews(health: Int) {
        let normalizedHealth = health >= 0 ? health : 0

        let healthDisplays = stride(from: 0, to: normalizedHealth, by: 1)
            .map { _ in
                HeartDisplay(position: Vector2D.outOfScreen, zPosition: Constants.ZPOSITION_HEALTH_DISPLAY + 1)
            }

        healthDisplayView.changeItems(to: healthDisplays)
    }
}

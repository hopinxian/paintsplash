//
//  AttackButton.swift
//  paintsplash
//
//  Created by Praveen Bala on 17/3/21.
//

import Foundation

class AttackButton: UIEntity, Renderable {
    var renderComponent: RenderComponent
    var transformComponent: TransformComponent

    private let associatedEntity: EntityID
    private var tracking = false
    private var radius: Double {
        transformComponent.size.x / 2
    }

    init(associatedEntityID: EntityID) {
        self.associatedEntity = associatedEntityID

        self.renderComponent = RenderComponent(
            renderType: .sprite(spriteName: Constants.ATTACK_BUTTON_SPRITE),
            zPosition: Constants.ZPOSITION_JOYSTICK
        )

        self.transformComponent = TransformComponent(
            position: Constants.ATTACK_BUTTON_POSITION,
            rotation: 0,
            size: Constants.ATTACK_BUTTON_SIZE
        )

        super.init()

        EventSystem.inputEvents.touchDownEvent.subscribe(listener: { [weak self] in self?.onTouchDown(event: $0) })
        EventSystem.inputEvents.touchUpEvent.subscribe(listener: { [weak self] in self?.onTouchUp(event: $0) })
    }

    func onTouchDown(event: TouchDownEvent) {
        if Vector2D.magnitude(of: event.location - transformComponent.localPosition) < radius {
            tracking = true
        }
    }

    func onTouchUp(event: TouchUpEvent) {
        guard tracking else {
            return
        }

        tracking = false
        let event = PlayerShootEvent(
            direction: Vector2D.up,
            playerID: associatedEntity
        )
        EventSystem.processedInputEvents.playerShootEvent.post(event: event)
    }
}

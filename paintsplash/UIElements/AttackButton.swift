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
        let renderType = RenderType.sprite(spriteName: Constants.ATTACK_BUTTON_SPRITE)
        self.associatedEntity = associatedEntityID
        self.renderComponent = RenderComponent(
            renderType: renderType,
            zPosition: Constants.ZPOSITION_UI_ELEMENT
        )

        self.transformComponent = TransformComponent(
            position: Constants.ATTACK_BUTTON_POSITION,
            rotation: 0,
            size: Constants.ATTACK_BUTTON_SIZE
        )

        super.init()

        EventSystem.inputEvents.touchDownEvent.subscribe(listener: onTouchDown)
        EventSystem.inputEvents.touchUpEvent.subscribe(listener: onTouchUp)
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
        let event = PlayerShootEvent(direction: Vector2D.up, playerID: associatedEntity)
        EventSystem.processedInputEvents.playerShootEvent.post(event: event)
    }
}

//
//  BombButton.swift
//  paintsplash
//
//  Created by Farrell Nah on 13/4/21.
//

class BombButton: UIEntity, Renderable {
    var renderComponent: RenderComponent
    var transformComponent: TransformComponent

    private let associatedEntity: EntityID
    private var tracking = false
    private var radius: Double {
        transformComponent.size.x / 2
    }

    init(associatedEntityID: EntityID, position: Vector2D) {
        self.associatedEntity = associatedEntityID

        self.renderComponent = RenderComponent(
            renderType: .sprite(spriteName: "WhiteSquare"),
            zPosition: Constants.ZPOSITION_JOYSTICK
        )

        self.transformComponent = TransformComponent(
            position: position,
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
        let event = PlayerBombEvent(
            direction: Vector2D.right,
            playerID: associatedEntity
        )
        EventSystem.processedInputEvents.playerBombEvent.post(event: event)
    }
}

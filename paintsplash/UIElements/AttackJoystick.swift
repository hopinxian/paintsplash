//
//  AttackJoystick.swift
//  paintsplash
//
//  Created by Farrell Nah on 3/4/21.
//

class AttackJoystick: Joystick {
    private var lastDisplacement: Vector2D = .zero

    override func onTouchMoved(event: TouchMovedEvent) {
        guard tracking else {
            return
        }

        super.onTouchMoved(event: event)
        lastDisplacement = displacement

        let event = PlayerAimEvent(direction: lastDisplacement, playerID: associatedEntity)
        EventSystem.processedInputEvents.playerAimEvent.post(event: event)
    }

    override func onTouchUp(event: TouchUpEvent) {
        guard tracking else {
            return
        }

        super.onTouchUp(event: event)

        let event = PlayerShootEvent(
            direction: lastDisplacement,
            playerID: associatedEntity
        )
        EventSystem.processedInputEvents.playerShootEvent.post(event: event)
        lastDisplacement = .zero
    }
}

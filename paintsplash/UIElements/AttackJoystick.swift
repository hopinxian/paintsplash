//
//  AttackJoystick.swift
//  paintsplash
//
//  Created by Farrell Nah on 3/4/21.
//

class AttackJoystick: Joystick {
    private var lastDisplacement: Vector2D = .zero

    override func touchMove(event: TouchMoveEvent) {
        guard event.associatedId == trackedId else {
            return
        }

        super.touchMove(event: event)
        lastDisplacement = displacement

        let event = PlayerAimEvent(direction: lastDisplacement, playerID: associatedEntity)
        EventSystem.processedInputEvents.playerAimEvent.post(event: event)
    }

    override func touchUp(event: TouchUpEvent) {
        guard event.associatedId == trackedId else {
            return
        }

        super.touchUp(event: event)

        let event = PlayerShootEvent(
            direction: lastDisplacement,
            playerID: associatedEntity
        )
        EventSystem.processedInputEvents.playerShootEvent.post(event: event)
        lastDisplacement = .zero
    }
}

//
//  MovementJoystick.swift
//  paintsplash
//
//  Created by Farrell Nah on 3/4/21.
//

class MovementJoystick: Joystick {
    override func touchMove(event: TouchMoveEvent) {
        guard event.touchId == trackedId else {
            return
        }

        super.touchMove(event: event)
        let event = PlayerMoveEvent(direction: displacement, playerID: associatedEntity)
        EventSystem.processedInputEvents.playerMoveEvent.post(event: event)
    }

    override func touchUp(event: TouchUpEvent) {
        guard event.touchId == trackedId else {
            return
        }

        super.touchUp(event: event)

        let event = PlayerMoveEvent(direction: Vector2D.zero, playerID: associatedEntity)
        EventSystem.processedInputEvents.playerMoveEvent.post(event: event)
    }
}

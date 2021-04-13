//
//  MovementJoystick.swift
//  paintsplash
//
//  Created by Farrell Nah on 3/4/21.
//

class MovementJoystick: Joystick {
    override func onTouchMoved(event: TouchMovedEvent) {
        guard event.associatedId == trackedId else {
            return
        }

        super.onTouchMoved(event: event)
        let event = PlayerMoveEvent(direction: displacement, playerID: associatedEntity)
        EventSystem.processedInputEvents.playerMoveEvent.post(event: event)
    }

    override func onTouchUp(event: TouchUpEvent) {
        guard event.associatedId == trackedId else {
            return
        }

        super.onTouchUp(event: event)

        let event = PlayerMoveEvent(direction: Vector2D.zero, playerID: associatedEntity)
        EventSystem.processedInputEvents.playerMoveEvent.post(event: event)
    }
}

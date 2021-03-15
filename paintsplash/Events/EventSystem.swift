//
//  EventSystem.swift
//  paintsplash
//
//  Created by Farrell Nah on 15/3/21.
//

class EventSystem {
    static let collisionEvents = CollisionEventManager()
    static let inputEvents = InputEventManager()
    static let entityMovementEvent = EntityMovementEvent()
}

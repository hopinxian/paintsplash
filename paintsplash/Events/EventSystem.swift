//
//  EventSystem.swift
//  paintsplash
//
//  Created by Farrell Nah on 15/3/21.
//

class EventSystem {
    static let collisionEvents = CollisionEventManager()
    static let inputEvents = TouchInputEventManager()
    static let entityMovementEvent = EntityMovementEvent()
    static let playerHasMovedEvent = PlayerHasMovedEventManager()
    static let processedInputEvent = ProcessedInputEventManager()
    static let changeViewEvent = ChangeViewEventManager()
}

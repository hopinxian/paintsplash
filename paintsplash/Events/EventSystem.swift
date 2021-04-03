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
    static let playerActionEvent = PlayerActionEventManager()
    static let changeViewEvent = ChangeViewEventManager()
    static let processedInputEvents = ProcessedInputEventManager()
    static let entityChangeEvents = EntityChangeEventManager()
    static let canvasEvent = CanvasEventManager()
    static let scoreEvent = ScoreEventManager()
    static let audioEvent = AudioEventManager()
}

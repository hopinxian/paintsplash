//
//  EventSystem.swift
//  paintsplash
//
//  Created by Farrell Nah on 15/3/21.
//

class EventSystem {
    static let rawTouchInputEvent = RawTouchInputEventManager()
    static let inputEvents = TouchInputEventManager()
    static let playerActionEvent = PlayerActionEventManager()
    static let processedInputEvents = ProcessedInputEventManager()
    static let entityChangeEvents = EntityChangeEventManager()
    static let canvasEvent = CanvasEventManager()
    static let scoreEvent = ScoreEventManager()
    static let audioEvent = AudioEventManager()
}

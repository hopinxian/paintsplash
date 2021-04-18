//
//  EventSystem.swift
//  paintsplash
//
//  Created by Farrell Nah on 15/3/21.
//

class EventSystem {
    static let processedInputEvents = ProcessedInputEventManager()
    static let playerActionEvent = PlayerActionEventManager()
    static let entityChangeEvents = EntityChangeEventManager()
    static let canvasEvent = CanvasEventManager()
    static let scoreEvent = ScoreEventManager()
    static let audioEvent = AudioEventManager()
    static let gameStateEvents = GameStateEventManager()

    static func reset() {
        EventSystem.processedInputEvents.reset()
        EventSystem.playerActionEvent.reset()
        EventSystem.entityChangeEvents.reset()
        EventSystem.canvasEvent.reset()
        EventSystem.scoreEvent.reset()
        EventSystem.audioEvent.reset()
        EventSystem.gameStateEvents.reset()
    }
}

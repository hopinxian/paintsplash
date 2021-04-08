//
//  GameStateEventManager.swift
//  paintsplash
//
//  Created by Farrell Nah on 8/4/21.
//

class GameStateEventManager: EventManager<GameStateEvent> {
    let gameOverEvent = EventManager<GameOverEvent>()

    override func subscribe(listener: @escaping (GameStateEvent) -> Void) {
        super.subscribe(listener: listener)
        gameOverEvent.subscribe(listener: listener)
    }
}

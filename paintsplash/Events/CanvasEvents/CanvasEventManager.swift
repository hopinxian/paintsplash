//
//  CanvasHitEventManager.swift
//  paintsplash
//
//  Created by Cynthia Lee on 19/3/21.
//

class CanvasEventManager: EventManager<CanvasEvent> {
    let canvasHitEvent = EventManager<CanvasHitEvent>()
    let canvasEndEvent = EventManager<CanvasEndEvent>()

    override func subscribe(listener: @escaping (CanvasEvent) -> Void) {
        super.subscribe(listener: listener)
        canvasHitEvent.subscribe(listener: listener)
        canvasEndEvent.subscribe(listener: listener)
    }
}

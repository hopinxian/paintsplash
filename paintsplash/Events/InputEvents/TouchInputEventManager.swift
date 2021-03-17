//
//  InputEventManager.swift
//  paintsplash
//
//  Created by Farrell Nah on 15/3/21.
//

class TouchInputEventManager: EventManager<TouchInputEvent> {
    let touchUpEvent = EventManager<TouchUpEvent>()
    let touchDownEvent = EventManager<TouchDownEvent>()
    let touchMovedEvent = EventManager<TouchMovedEvent>()

    override func subscribe(listener: @escaping (TouchInputEvent) -> Void) {
        super.subscribe(listener: listener)
        touchUpEvent.subscribe(listener: listener)
        touchDownEvent.subscribe(listener: listener)
        touchMovedEvent.subscribe(listener: listener)
    }
}

//
//  RawTouchInputEventManager.swift
//  paintsplash
//
//  Created by Praveen Bala on 6/4/21.
//

class RawTouchInputEventManager: EventManager<RawTouchInputEvent> {
    let rawTouchUpEvent = EventManager<RawTouchUpEvent>()
    let rawTouchDownEvent = EventManager<RawTouchDownEvent>()
    let rawTouchMovedEvent = EventManager<RawTouchMovedEvent>()

    override func subscribe(listener: @escaping (RawTouchInputEvent) -> Void) {
        super.subscribe(listener: listener)
        rawTouchUpEvent.subscribe(listener: listener)
        rawTouchDownEvent.subscribe(listener: listener)
        rawTouchMovedEvent.subscribe(listener: listener)
    }
}

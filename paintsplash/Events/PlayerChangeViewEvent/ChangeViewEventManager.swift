//
//  ChangeViewEventManager.swift
//  paintsplash
//
//  Created by Praveen Bala on 17/3/21.
//

class ChangeViewEventManager: EventManager<ChangeViewEvent> {
    let changeAnimationEvent = EventManager<ChangeAnimationEvent>()
    let addSubviewEvent = EventManager<AddSubviewEvent>()

    override func subscribe(listener: @escaping (ChangeViewEvent) -> Void) {
        super.subscribe(listener: listener)
        changeAnimationEvent.subscribe(listener: listener)
        addSubviewEvent.subscribe(listener: listener)
    }
}

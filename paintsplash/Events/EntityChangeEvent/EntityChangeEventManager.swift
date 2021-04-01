//
//  AddEntityEventManager.swift
//  paintsplash
//
//  Created by Farrell Nah on 16/3/21.
//

class EntityChangeEventManager: EventManager<EntityChangeEvent> {
    let addEntityEvent = EventManager<AddEntityEvent>()
    let removeEntityEvent = EventManager<RemoveEntityEvent>()
    let addUIEntityEvent = EventManager<AddUIEntityEvent>()
    let removeUIEntityEvent = EventManager<RemoveUIEntityEvent>()

    override func subscribe(listener: @escaping (EntityChangeEvent) -> Void) {
        super.subscribe(listener: listener)
        addEntityEvent.subscribe(listener: listener)
        removeEntityEvent.subscribe(listener: listener)
        addUIEntityEvent.subscribe(listener: listener)
        removeUIEntityEvent.subscribe(listener: listener)
    }
}

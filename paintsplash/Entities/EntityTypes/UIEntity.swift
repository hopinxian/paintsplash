//
//  UIEntity.swift
//  paintsplash
//
//  Created by Farrell Nah on 3/4/21.
//

class UIEntity: GameEntity {
    override init() {
        super.init()
        self.id = EntityID(id: "L" + self.id.id)
    }

    override func spawn() {
        EventSystem.entityChangeEvents.addUIEntityEvent.post(event: AddUIEntityEvent(entity: self))
    }

    override func destroy() {
        EventSystem.entityChangeEvents.removeUIEntityEvent.post(event: RemoveUIEntityEvent(entity: self))
    }
}

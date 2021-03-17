//
//  AddObjectEvent.swift
//  paintsplash
//
//  Created by Farrell Nah on 16/3/21.
//

class EntityChangeEvent: Event {
    let entity: GameEntity

    init(entity: GameEntity) {
        self.entity = entity
    }
}

class AddEntityEvent: EntityChangeEvent {

}

class RemoveEntityEvent: EntityChangeEvent {

}

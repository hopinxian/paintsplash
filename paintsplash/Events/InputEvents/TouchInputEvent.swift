//
//  InputEvent.swift
//  paintsplash
//
//  Created by Farrell Nah on 15/3/21.
//

class TouchInputEvent: Event {
    let location: Vector2D
    let associatedId: EntityID

    init(location: Vector2D, associatedId: EntityID) {
        self.location = location
        self.associatedId = associatedId
    }
}

class TouchUpEvent: TouchInputEvent {

}

class TouchDownEvent: TouchInputEvent {

}

class TouchMovedEvent: TouchInputEvent {

}

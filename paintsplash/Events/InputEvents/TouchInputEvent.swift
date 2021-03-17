//
//  InputEvent.swift
//  paintsplash
//
//  Created by Farrell Nah on 15/3/21.
//

class TouchInputEvent: Event {
    let location: Vector2D

    init(location: Vector2D) {
        self.location = location
    }
}

class TouchUpEvent: TouchInputEvent {

}

class TouchDownEvent: TouchInputEvent {

}

class TouchMovedEvent: TouchInputEvent {

}

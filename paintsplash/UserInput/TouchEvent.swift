//
//  TouchEvent.swift
//  paintsplash
//
//  Created by Praveen Bala on 17/4/21.
//

class TouchEvent {
    var location: Vector2D
    var touchId: EntityID

    init(location: Vector2D, touchId: EntityID) {
        self.location = location
        self.touchId = touchId
    }
}

class TouchDownEvent: TouchEvent {

}

class TouchUpEvent: TouchEvent {

}

class TouchMoveEvent: TouchEvent {

}

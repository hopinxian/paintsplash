//
//  RawTouchInputEvent.swift
//  paintsplash
//
//  Created by Praveen Bala on 6/4/21.
//

import SpriteKit

class RawTouchInputEvent: Event {
    let location: Vector2D
    let touchable: Touchable

    init(location: Vector2D, touchable: Touchable) {
        self.location = location
        self.touchable = touchable
    }
}

class RawTouchUpEvent: RawTouchInputEvent {

}

class RawTouchDownEvent: RawTouchInputEvent {

}

class RawTouchMovedEvent: RawTouchInputEvent {

}

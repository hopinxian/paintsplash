//
//  InputEvent.swift
//  paintsplash
//
//  Created by Farrell Nah on 15/3/21.
//

struct TouchInputEvent: Event {
    let inputState: TouchInputState
}

enum TouchInputState {
    case touchUp(location: Vector2D)
    case touchDown(location: Vector2D)
    case touchMoved(location: Vector2D)
}

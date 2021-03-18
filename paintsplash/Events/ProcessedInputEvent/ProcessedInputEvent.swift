//
//  ProcessedInputEvent.swift
//  paintsplash
//
//  Created by Farrell Nah on 15/3/21.
//

class ProcessedInputEvent: Event {
}

class PlayerMoveEvent: ProcessedInputEvent {
    let direction: Vector2D

    init(direction: Vector2D) {
        self.direction = direction
    }
}

class PlayerShootEvent: ProcessedInputEvent {
    let direction: Vector2D

    init(direction: Vector2D) {
        self.direction = direction
    }
}

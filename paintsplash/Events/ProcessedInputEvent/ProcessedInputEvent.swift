//
//  ProcessedInputEvent.swift
//  paintsplash
//
//  Created by Farrell Nah on 15/3/21.
//

struct ProcessedInputEvent: Event {
    let processedInputType: ProcessedInputType
}

enum ProcessedInputType {
    case playerMovement(direction: Vector2D)
    case playerShoot(direction: Vector2D)
}

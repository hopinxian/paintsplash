//
//  PlayerActionEvent.swift
//  paintsplash
//
//  Created by Praveen Bala on 17/3/21.
//

struct PlayerActionEvent: Event {
    let playerActionEventType: PlayerActionEventType
}

enum PlayerActionEventType {
    case movement(location: Vector2D)
    case attack
}

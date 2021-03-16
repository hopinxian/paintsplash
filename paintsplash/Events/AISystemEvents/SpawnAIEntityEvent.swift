//
//  SpawnAIEntityEvent.swift
//  paintsplash
//
//  Created by Cynthia Lee on 16/3/21.
//
struct SpawnAIEntityEvent: Event {
    let spawnEntityType: SpawnEntityType
}

enum SpawnEntityType {
    // TODO: add colour to enemy
    case enemy(location: Vector2D)
    case canvas(location: Vector2D)
}

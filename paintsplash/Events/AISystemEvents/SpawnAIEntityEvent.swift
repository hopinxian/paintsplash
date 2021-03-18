//
//  SpawnAIEntityEvent.swift
//  paintsplash
//
//  Created by Cynthia Lee on 16/3/21.
//
struct SpawnAIEntityEvent: Event, Equatable {
    let spawnEntityType: SpawnEntityType
}

enum SpawnEntityType: Equatable {
    case enemy(location: Vector2D, color: PaintColor)
    case canvas(location: Vector2D, velocity: Vector2D)
}
//
//  EventSystem.swift
//  paintsplash
//
//  Created by Farrell Nah on 15/3/21.
//

class EventSystem {
    static let collisionEvents = CollisionEventManager()
    static let inputEvents = TouchInputEventManager()
    static let entityMovementEvent = EntityMovementEvent()
    static let playerActionEvent = PlayerActionEventManager()
    static let changeViewEvent = ChangeViewEventManager()
    static let processedInputEvents = ProcessedInputEventManager()
    static let playerAmmoUpdateEvent = PlayerAmmoUpdateEventManager()
    static let entityChangeEvents = EntityChangeEventManager()
    static let spawnAIEntityEvent = SpawnAIEntityEventManager()
    static let despawnAIEntityEvent = DespawnAIEntityEventManager()
}

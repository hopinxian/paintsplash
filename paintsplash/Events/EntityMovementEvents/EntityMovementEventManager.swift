//
//  EntityMovementEventManager.swift
//  paintsplash
//
//  Created by Farrell Nah on 15/3/21.
//

class EntityMovementEventManager: EventManager {
    var listeners = [((EntityMovementEvent) -> Void)?]()
}

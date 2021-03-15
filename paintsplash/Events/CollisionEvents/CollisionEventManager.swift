//
//  CollisionEventManager.swift
//  paintsplash
//
//  Created by Farrell Nah on 15/3/21.
//

class CollisionEventManager: EventManager {
    var listeners = [((CollisionEvent) -> Void)?]()
}

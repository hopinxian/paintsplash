//
//  RemoveEntityEventManager.swift
//  paintsplash
//
//  Created by Farrell Nah on 16/3/21.
//

class RemoveEntityEventManager: EventManager {
    var listeners = [((RemoveEntityEvent) -> Void)?]()
}

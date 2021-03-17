//
//  AddEntityEventManager.swift
//  paintsplash
//
//  Created by Farrell Nah on 16/3/21.
//

class AddEntityEventManager: EventManager {
    var listeners = [((AddEntityEvent) -> Void)?]()
}

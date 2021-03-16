//
//  PlayerHasMovedEventManager.swift
//  paintsplash
//
//  Created by Farrell Nah on 15/3/21.
//

class PlayerHasMovedEventManager: EventManager {
    var listeners = [((PlayerHasMovedEvent) -> Void)?]()
}

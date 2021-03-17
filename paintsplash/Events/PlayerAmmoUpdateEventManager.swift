//
//  PlayerHasShotEventManager.swift
//  paintsplash
//
//  Created by Farrell Nah on 16/3/21.
//

class PlayerAmmoUpdateEventManager: EventManager {
    var listeners = [((PlayerAmmoUpdateEvent) -> Void)?]()
}

//
//  PlayerActionEventManager.swift
//  paintsplash
//
//  Created by Praveen Bala on 17/3/21.
//

class PlayerActionEventManager: EventManager {
    var listeners = [((PlayerActionEvent) -> Void)?]()
}

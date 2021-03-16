//
//  ChangeAnimationEventManager.swift
//  paintsplash
//
//  Created by Praveen Bala on 17/3/21.
//

class ChangeAnimationEventManager: EventManager {
    var listeners = [((ChangeAnimationEvent) -> Void)?]()
}


//
//  InputEventManager.swift
//  paintsplash
//
//  Created by Farrell Nah on 15/3/21.
//

class TouchInputEventManager: EventManager {
    var listeners = [((TouchInputEvent) -> Void)?]()
}

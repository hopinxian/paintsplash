//
//  InputEventManager.swift
//  paintsplash
//
//  Created by Farrell Nah on 15/3/21.
//

class InputEventManager: EventManager {
    var listeners = [((InputEvent) -> Void)?]()
}

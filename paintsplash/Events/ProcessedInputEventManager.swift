//
//  ProcessedInputEventManager.swift
//  paintsplash
//
//  Created by Farrell Nah on 15/3/21.
//

class ProcessedInputEventManager: EventManager {
    var listeners = [((ProcessedInputEvent) -> Void)?]()
}

//
//  EventManager.swift
//  paintsplash
//
//  Created by Farrell Nah on 15/3/21.
//

protocol EventManager: AnyObject {
    associatedtype EventType: Event
    var listeners: [((EventType) -> Void)?] { get set }

    func subscribe(listener: @escaping (EventType) -> Void)
    func post(event: EventType)
}

extension EventManager {
    func subscribe(listener: @escaping (EventType) -> Void) {
        listeners.append(listener)
    }

    func post(event: EventType) {
        listeners = listeners.compactMap { $0 }
        listeners.forEach { $0?(event) }
    }
}

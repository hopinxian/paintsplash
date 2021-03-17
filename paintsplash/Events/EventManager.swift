//
//  EventManager.swift
//  paintsplash
//
//  Created by Farrell Nah on 15/3/21.
//

class EventManager<EventType: Event> {
    var listeners = [((EventType) -> Void)?]()

    func subscribe(listener: @escaping (EventType) -> Void) {
        listeners.append(listener)
    }

    func post(event: EventType) {
        listeners = listeners.compactMap { $0 }
        listeners.forEach { $0?(event) }
    }
}

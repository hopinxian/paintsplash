//
//  DespawnAIEntityEventManager.swift
//  paintsplash
//
//  Created by Cynthia Lee on 17/3/21.
//

class DespawnAIEntityEventManager: EventManager {
    var listeners = [((DespawnAIEntityEvent) -> Void)?]()
}

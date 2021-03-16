//
//  SpawnAIEntityEventManager.swift
//  paintsplash
//
//  Created by Cynthia Lee on 16/3/21.
//

class SpawnAIEntityEventManager: EventManager {
    var listeners = [((SpawnAIEntityEvent) -> Void)?]()
}

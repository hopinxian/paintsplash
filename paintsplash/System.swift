//
//  System.swift
//  paintsplash
//
//  Created by Farrell Nah on 22/3/21.
//

protocol System {
    func addEntity(_ entity: GameEntity)
    func removeEntity(_ entity: GameEntity)
    func updateEntities(_ deltaTime: Double)
}

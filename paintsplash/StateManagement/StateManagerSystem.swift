//
//  AISystem.swift
//  paintsplash
//
//  Created by Cynthia Lee on 14/3/21.
//

protocol StateManagerSystem: System {
    var aiEntities: [GameEntity: StatefulEntity] { get set }
    func updateEntity(_ entity: GameEntity, _ aiEntity: StatefulEntity)
}

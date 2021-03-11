//
//  AIEntity.swift
//  paintsplash
//
//  Created by Farrell Nah on 10/3/21.
//

protocol AIEntity: Entity, Movable {
    var currentBehaviour: AIBehaviour { get }

    func update(aiGameInfo: AIGameInfo)
    func changeBehaviour(to behaviour: AIBehaviour)
}

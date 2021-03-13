//
//  AIEntity.swift
//  paintsplash
//
//  Created by Farrell Nah on 10/3/21.
//

protocol AIEntity: GameEntity, Movable {
    var currentBehaviour: AIBehaviour { get }

    func updateAI(aiGameInfo: AIGameInfo)
    func changeBehaviour(to behaviour: AIBehaviour)
}

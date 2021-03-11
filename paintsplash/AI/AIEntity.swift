//
//  AIEntity.swift
//  paintsplash
//
//  Created by Farrell Nah on 10/3/21.
//

protocol AIEntity: Entity {
    var currentBehaviour: AIBehaviour { get }

    func update()
    func changeBehaviour(to behaviour: AIBehaviour)
}

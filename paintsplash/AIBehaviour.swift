//
//  AIBehaviour.swift
//  paintsplash
//
//  Created by Farrell Nah on 9/3/21.
//

protocol AIEntity {
    var currentBehaviour: AIBehaviour { get }

    func update()
    func changeBehaviour(to behaviour: AIBehaviour)
}

protocol AIBehaviour {
    func update()
}

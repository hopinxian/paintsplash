//
//  BehaviourSequence.swift
//  paintsplash
//
//  Created by Farrell Nah on 24/3/21.
//

/// A behaviour that is composed of a sequence of other behaviours.
struct BehaviourSequence: StateBehaviour {
    let behaviours: [StateBehaviour]

    func run(statefulEntity: StatefulEntity, gameInfo: GameInfo) {
        for behaviour in behaviours {
            behaviour.run(statefulEntity: statefulEntity, gameInfo: gameInfo)
        }
    }
}

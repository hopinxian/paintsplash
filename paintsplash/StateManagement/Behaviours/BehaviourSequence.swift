//
//  BehaviourSequence.swift
//  paintsplash
//
//  Created by Farrell Nah on 24/3/21.
//

class BehaviourSequence: StateBehaviour {
    let behaviours: [StateBehaviour]

    init(behaviours: [StateBehaviour]) {
        self.behaviours = behaviours
    }

    func updateAI(aiEntity: StatefulEntity, aiGameInfo: GameInfo) {
        for behaviour in behaviours {
            behaviour.updateAI(aiEntity: aiEntity, aiGameInfo: aiGameInfo)
        }
    }
}

//
//  BehaviourSequence.swift
//  paintsplash
//
//  Created by Farrell Nah on 24/3/21.
//

class BehaviourSequence: AIBehaviour {
    let behaviours: [AIBehaviour]

    init(behaviours: [AIBehaviour]) {
        self.behaviours = behaviours
    }

    func updateAI(aiEntity: AIEntity, aiGameInfo: AIGameInfo) {
        for behaviour in behaviours {
            behaviour.updateAI(aiEntity: aiEntity, aiGameInfo: aiGameInfo)
        }
    }
}

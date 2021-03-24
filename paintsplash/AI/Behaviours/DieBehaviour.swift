//
//  DieBehaviour.swift
//  paintsplash
//
//  Created by Farrell Nah on 24/3/21.
//

struct DieBehaviour: AIBehaviour {
    func updateAI(aiEntity: AIEntity, aiGameInfo: AIGameInfo) {
        aiEntity.destroy()
    }
}

//
//  DieBehaviour.swift
//  paintsplash
//
//  Created by Farrell Nah on 24/3/21.
//

struct DieBehaviour: StateBehaviour {
    func updateAI(aiEntity: StatefulEntity, aiGameInfo: AIGameInfo) {
        aiEntity.destroy()
    }
}

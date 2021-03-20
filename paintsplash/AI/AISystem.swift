//
//  AISystem.swift
//  paintsplash
//
//  Created by Cynthia Lee on 14/3/21.
//
protocol AISystem {

}

class NewAISystem: AISystem {
    func updateAIEntities(_ entities: [AIComponent]) {
        for data in entities {
            updateAIEntity(data)
        }
    }

    func updateAIEntity(_ data: AIComponent) {
        data.behaviour.updateAI(aiEntity: data.entity, aiGameInfo: ?)
    }
}


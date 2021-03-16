//
//  CanvasBehaviour.swift
//  paintsplash
//
//  Created by Cynthia Lee on 16/3/21.
//

struct CanvasBehaviour: AIBehaviour {
    func updateAI(aiEntity: AIEntity, aiGameInfo: AIGameInfo) {
        aiEntity.move()
    }
}

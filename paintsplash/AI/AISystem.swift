//
//  AISystem.swift
//  paintsplash
//
//  Created by Cynthia Lee on 14/3/21.
//
protocol AISystem {
    var AIEntities: [AIEntity] { get set }

    func updateAIEntities(aiGameInfo: AIGameInfo)

    func add(aiEntity: AIEntity)

    func remove(aiEntity: AIEntity)
}


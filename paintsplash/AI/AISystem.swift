//
//  AISystem.swift
//  paintsplash
//
//  Created by Cynthia Lee on 14/3/21.
//
protocol AISystem {
    var AIEntities: Set<AIEntity> { get set }

    func updateAIEntities()

    func add(aiEntity: AIEntity)

    func remove(aiEntity: AIEntity)

    func update(aiEntity: AIEntity)
}


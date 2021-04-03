//
//  GameManager.swift
//  paintsplash
//
//  Created by Farrell Nah on 13/3/21.
//

protocol GameManager: AnyObject {
    var entities: Set<GameEntity> { get set }
    var uiEntities: Set<GameEntity> { get set }

    func addObject(_ object: GameEntity)
    func removeObject(_ object: GameEntity)

    func update()
}

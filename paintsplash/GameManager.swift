//
//  GameManager.swift
//  paintsplash
//
//  Created by Farrell Nah on 13/3/21.
//

protocol GameManager {
    var entities: Set<GameEntity> { get set }

    var currentLevel: Level? { get set }

    var aiSystem: AISystem! { get }
    var audioManager: AudioSystem! { get }
    var renderSystem: RenderSystem! { get }
    var animationSystem: AnimationSystem! { get }
    var collisionSystem: CollisionSystem! { get }
    var movementSystem: MovementSystem! { get }

    func addObject(_ object: GameEntity)
    func removeObject(_ object: GameEntity)

    func update()
}

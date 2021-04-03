//
//  AIEntityState.swift
//  paintsplash
//
//  Created by Cynthia Lee on 14/3/21.
//
import Foundation

protocol AIState {
    func getStateTransition(aiEntity: AIEntity) -> AIState?
    func getBehaviour(aiEntity: AIEntity) -> AIBehaviour
}

protocol AIStateManager {
    var currentState: AIState { get set }
    func transitionState(aiEntity: AIEntity)
}

enum EnemySpawnerState {}

extension EnemySpawnerState {
    struct Idle: AIState {
        let idleTime: Double
        private let startTime: Date

        init(idleTime: Double) {
            self.idleTime = idleTime
            self.startTime = Date()
        }

        func getStateTransition(aiEntity: AIEntity) -> AIState? {
            let timeSinceStart = Date().timeIntervalSince(startTime)
            if timeSinceStart > idleTime {
                return Spawning()
            }
            return nil
        }

        func getBehaviour(aiEntity: AIEntity) -> AIBehaviour {
            BehaviourSequence(behaviours: [DoNothingBehaviour(),
                                           UpdateAnimationBehaviour(animation: SpawnerAnimations.spawnerIdle,
                                                                    interupt: false)])
        }
    }

    struct Spawning: AIState {
        var completed = false

        func getStateTransition(aiEntity: AIEntity) -> AIState? {
            Idle(idleTime: 3)
        }

        func getBehaviour(aiEntity: AIEntity) -> AIBehaviour {
            BehaviourSequence(
                behaviours: [
                    SpawnEnemyBehaviour(spawnQuantity: 1),
                    UpdateAnimationBehaviour(animation: SpawnerAnimations.spawnerSpawn, interupt: true)
                ]
            )
        }
    }
}

enum CanvasSpawnerState {}

extension CanvasSpawnerState {
    struct Idle: AIState {
        let idleTime: Double
        private let startTime: Date

        init(idleTime: Double) {
            self.idleTime = idleTime
            self.startTime = Date()
        }

        func getStateTransition(aiEntity: AIEntity) -> AIState? {
            let timeSinceStart = Date().timeIntervalSince(startTime)
            if timeSinceStart > idleTime {
                return Spawning()
            }
            return nil
        }

        func getBehaviour(aiEntity: AIEntity) -> AIBehaviour {
            DoNothingBehaviour()
        }
    }

    struct Spawning: AIState {
        var completed = false

        func getStateTransition(aiEntity: AIEntity) -> AIState? {
            Idle(idleTime: 10)
        }

        func getBehaviour(aiEntity: AIEntity) -> AIBehaviour {
            SpawnCanvasBehaviour()
        }
    }
}

enum EnemyState {}

extension EnemyState {
    struct Idle: AIState {
        func getStateTransition(aiEntity: AIEntity) -> AIState? {
            Chasing()
        }

        func getBehaviour(aiEntity: AIEntity) -> AIBehaviour {
            BehaviourSequence(behaviours: [DoNothingBehaviour(), UpdateAnimationBehaviour(animation: SlimeAnimations.slimeIdleGray, interupt: false)])

        }
    }

    struct Chasing: AIState {
        func getStateTransition(aiEntity: AIEntity) -> AIState? {
            nil
        }

        func getBehaviour(aiEntity: AIEntity) -> AIBehaviour {
            if let movable = aiEntity as? Movable {
                let updateAnimationBehaviour = movable.moveableComponent.direction.x > 0 ?
                    UpdateAnimationBehaviour(animation: SlimeAnimations.slimeMoveRightGray, interupt: false) :
                    UpdateAnimationBehaviour(animation: SlimeAnimations.slimeMoveLeftGray, interupt: false)

                return BehaviourSequence(
                    behaviours: [
                        ChasePlayerBehaviour(),
                        updateAnimationBehaviour
                    ]
                )
            } else {
                return ChasePlayerBehaviour()
            }
        }
    }
}

enum CanvasState {}

extension CanvasState {
    struct Moving: AIState {
        var endX: Double?

        func getStateTransition(aiEntity: AIEntity) -> AIState? {
            nil
        }

        func getBehaviour(aiEntity: AIEntity) -> AIBehaviour {
            MoveBehaviour(direction: Vector2D(1, 0), speed: 1)
        }
    }
}

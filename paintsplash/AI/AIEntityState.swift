//
//  AIEntityState.swift
//  paintsplash
//
//  Created by Cynthia Lee on 14/3/21.
//
import Foundation

class AIState {
    func getStateTransition() -> AIState? {
         nil
    }
    func getBehaviour() -> AIBehaviour {
        DoNothingBehaviour()
    }
    func onEnterState() {

    }
    func onLeaveState() {

    }
    func onStayState() {

    }
}

protocol AIStateManager {
    var currentState: AIState { get set }
    func transitionState(aiEntity: AIEntity)
}

class EnemySpawnerState: AIState {
    let spawner: EnemySpawner

    init(spawner: EnemySpawner) {
        self.spawner = spawner
    }

    class Idle: EnemySpawnerState {
        let idleTime: Double
        private let startTime: Date

        init(spawner: EnemySpawner, idleTime: Double) {
            self.idleTime = idleTime
            self.startTime = Date()
            super.init(spawner: spawner)
        }

        override func onEnterState() {
            spawner.animationComponent.animate(animation: SpawnerAnimations.spawnerIdle, interupt: false)
        }

        override func getStateTransition() -> AIState? {
            let timeSinceStart = Date().timeIntervalSince(startTime)
            if timeSinceStart > idleTime {
                return Spawning(spawner: spawner)
            }
            return nil
        }
    }

    class Spawning: EnemySpawnerState {
        private var complete = false

        override func onEnterState() {
            spawner.animationComponent.animate(
                animation: SpawnerAnimations.spawnerSpawn,
                interupt: true,
                callBack: {
                    self.spawner.aiComponent.currentState = Idle(spawner: self.spawner, idleTime: 3.0)

                }
            )
        }

        override func getBehaviour() -> AIBehaviour {
            if !complete {
                complete = true
                return SpawnEnemyBehaviour(spawnQuantity: 1)
            }

            return DoNothingBehaviour()
        }
    }

    class Hit: EnemySpawnerState {
        override func onEnterState() {
            spawner.animationComponent.animate(
                animation: SpawnerAnimations.spawnerHit,
                interupt: true,
                callBack: {
                    self.spawner.aiComponent.currentState = Idle(spawner: self.spawner, idleTime: 3.0)

                }
            )
        }
    }

    class Die: EnemySpawnerState {
        override func onEnterState() {
            spawner.animationComponent.animate(animation: SpawnerAnimations.spawnerSpawn, interupt: true, callBack: { self.spawner.destroy() })
        }

        override func getStateTransition() -> AIState? {
            Idle(spawner: spawner, idleTime: 3)
        }

        override func getBehaviour() -> AIBehaviour {
            BehaviourSequence(
                behaviours: [
                    SpawnEnemyBehaviour(spawnQuantity: 1),
                    UpdateAnimationBehaviour(animation: SpawnerAnimations.spawnerSpawn, interupt: true)
                ]
            )
        }
    }
}

class CanvasSpawnerState: AIState {
    let spawner: CanvasSpawner

    init(spawner: CanvasSpawner) {
        self.spawner = spawner
    }

    class Idle: CanvasSpawnerState {
        let idleTime: Double
        private let startTime: Date

        init(spawner: CanvasSpawner, idleTime: Double) {
            self.idleTime = idleTime
            self.startTime = Date()
            super.init(spawner: spawner)
        }

        override func getStateTransition() -> AIState? {
            let timeSinceStart = Date().timeIntervalSince(startTime)
            if timeSinceStart > idleTime {
                return Spawning(spawner: spawner)
            }
            return nil
        }
    }

    class Spawning: CanvasSpawnerState {
        private var complete = false

        override func getStateTransition() -> AIState? {
            Idle(spawner: spawner, idleTime: 10)
        }

        override func getBehaviour() -> AIBehaviour {
            if !complete {
                complete = true
                return SpawnCanvasBehaviour()
            }

            return DoNothingBehaviour()
        }
    }
}

class EnemyState: AIState {
    let enemy: Enemy

    init(enemy: Enemy) {
        self.enemy = enemy
    }

    class Idle: EnemyState {
        override func onEnterState() {
            enemy.animationComponent.animate(animation: SlimeAnimations.slimeIdleGray, interupt: true)
        }

        override func getStateTransition() -> AIState? {
            Chasing(enemy: enemy)
        }
    }

    class Chasing: EnemyState {
        override func onEnterState() {
            if enemy.moveableComponent.direction.x > 0 {
                enemy.animationComponent.animate(animation: SlimeAnimations.slimeMoveRightGray, interupt: true)
            } else {
                enemy.animationComponent.animate(animation: SlimeAnimations.slimeMoveLeftGray, interupt: true)
            }

            enemy.lastDirection = enemy.moveableComponent.direction
        }

        override func getStateTransition() -> AIState? {
            if enemy.lastDirection.x * enemy.moveableComponent.direction.x <= 0 {
                return Chasing(enemy: enemy)
            }

            return nil
        }

        override func getBehaviour() -> AIBehaviour {
            ChasePlayerBehaviour()
        }
    }

    class Die: EnemyState {
        override func onEnterState() {
            enemy.animationComponent.animate(animation: SlimeAnimations.slimeDieGray, interupt: true, callBack: { self.enemy.destroy() })
        }
    }
}

class CanvasState: AIState {
    let canvas: Canvas

    init(canvas: Canvas) {
        self.canvas = canvas
    }

    class Moving: CanvasState {
        func getBehaviour(aiEntity: AIEntity) -> AIBehaviour {
            MoveBehaviour(direction: Vector2D(1, 0), speed: 1)
        }
    }
}

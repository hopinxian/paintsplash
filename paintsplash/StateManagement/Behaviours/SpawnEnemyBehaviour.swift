//
//  SpawnEnemiesBehaviour.swift
//  paintsplash
//
//  Created by Cynthia Lee on 11/3/21.
//
import Foundation

/// Spawns a number of enemies
struct SpawnEnemyBehaviour: StateBehaviour {
    let spawnQuantity: Int

    init(spawnQuantity: Int) {
        self.spawnQuantity = spawnQuantity
    }

    func run(statefulEntity: StatefulEntity, gameInfo: GameInfo) {
        guard let transformable = statefulEntity as? Transformable,
              let colorable = statefulEntity as? Colorable else {
            fatalError(
                "AIEntity does not conform to the required protocols for SpawnEnemyBehaviour"
            )
        }

        let yDisplacement = Vector2D(0, transformable.transformComponent.size.y / 2 - 10)
        let spawnPosition = transformable.transformComponent.localPosition - yDisplacement

        let subColors = colorable.color.getSubColors()

        for _ in 0..<spawnQuantity {
            guard let randomColor = subColors.randomElement() else {
                fatalError("Subcolors should never be empty.")
            }

            let enemy = Enemy(initialPosition: spawnPosition, color: randomColor)
            enemy.spawn()
        }
    }
}

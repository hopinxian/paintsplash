//
//  CanvasSpawner.swift
//  paintsplash
//
//  Created by Cynthia Lee on 16/3/21.
//

class CanvasSpawner: AIEntity {
    var canvasVelocity: Vector2D

    init(initialPosition: Vector2D, canvasVelocity: Vector2D) {
        self.canvasVelocity = canvasVelocity

        super.init(spriteName: "canvas-spawner", initialPosition: initialPosition, initialVelocity: .zero, radius: 1, tags: [])

        // TODO: determine spawn interval by canvas size, speed of movement
        self.currentBehaviour = SpawnCanvasBehaviour(spawnInterval: 2,
                                                     canvasVelocity: Vector2D(0.2, 0))
    }
}

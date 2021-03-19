//
//  CanvasSpawner.swift
//  paintsplash
//
//  Created by Cynthia Lee on 16/3/21.
//

class CanvasSpawner: AIEntity {
    private var canvasVelocity: Vector2D

    private var canvasSize: Vector2D

    private var spawnInterval: Double

    init(initialPosition: Vector2D, canvasVelocity: Vector2D, canvasSize: Vector2D, spawnInterval: Double) {
        self.canvasVelocity = canvasVelocity
        self.canvasSize = canvasSize
        self.spawnInterval = spawnInterval

        super.init(spriteName: "canvas-spawner", initialPosition: initialPosition, initialVelocity: .zero, radius: 1, tags: [])

        // TODO: determine spawn interval by canvas size, speed of movement
        self.currentBehaviour = SpawnCanvasBehaviour(spawnInterval: spawnInterval,
                                                     canvasVelocity: canvasVelocity,
                                                     canvasSize: canvasSize)
    }
}

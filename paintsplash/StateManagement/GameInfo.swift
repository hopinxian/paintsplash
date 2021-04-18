//
//  AIGameInfo.swift
//  paintsplash
//
//  Created by Cynthia Lee on 11/3/21.
//
import CoreGraphics

/// Contains important game data required for game mechanics to operate.
class GameInfo {
    var playerPosition: Vector2D
    var numberOfEnemies = 0
    var numberOfDrops = 0
    var existingEnemyColors: [PaintColor: Int] = [:]
    var requiredCanvasColors: [PaintColor: Int] = [:]
    var existingDropColors: [PaintColor: Int] = [:]
    var numEnemiesKilledRecently = 0

    init(playerPosition: Vector2D) {
        self.playerPosition = playerPosition
    }
}

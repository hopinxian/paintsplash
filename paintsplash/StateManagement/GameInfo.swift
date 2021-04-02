//
//  AIGameInfo.swift
//  paintsplash
//
//  Created by Cynthia Lee on 11/3/21.
//
import CoreGraphics

class GameInfo {
    var playerPosition: Vector2D
    var numberOfEnemies: Int
    var existingEnemyColors: [PaintColor: Int] = [:]
    var requiredCanvasColors: [PaintColor: Int] = [:]
    var existingDropColors: [PaintColor: Int] = [:]
    
    init(playerPosition: Vector2D, numberOfEnemies: Int) {
        self.playerPosition = playerPosition
        self.numberOfEnemies = numberOfEnemies
    }
}

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
    var numberOfDrops: Int = 0
    var existingEnemyColors: [PaintColor: Int] = [:]
    var requiredCanvasColors: [PaintColor: Int] = [:]
    var existingDropColors: [PaintColor: Int] = [:]

    init(playerPosition: Vector2D,
         numberOfEnemies: Int) {
        self.playerPosition = playerPosition
        self.numberOfEnemies = numberOfEnemies
    }
}

extension GameInfo: Copyable {
    func copy() -> Any {
        let info = GameInfo(
            playerPosition: self.playerPosition,
            numberOfEnemies: self.numberOfEnemies)
        info.numberOfDrops = self.numberOfDrops
        info.existingEnemyColors = self.existingEnemyColors
        info.requiredCanvasColors = self.requiredCanvasColors
        info.existingDropColors = self.existingDropColors
        return info
    }
}

//
//  LevelSpawnType.swift
//  paintsplash
//
//  Created by Ho Pin Xian on 19/3/21.
//

import UIKit

enum LevelSpawnType: Equatable {
    case enemy(location: Vector2D?, color: PaintColor?)
    case canvasSpawner(location: Vector2D?, velocity: Vector2D?)
    case enemySpawner(location: Vector2D?, color: PaintColor?)
    case ammoDrop(location: Vector2D?, color: PaintColor?)
}

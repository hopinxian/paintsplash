//
//  Points.swift
//  paintsplash
//
//  Created by Ho Pin Xian on 19/3/21.
//

struct Points {
    static let enemyKill = 100
    static let enemySpawnerKill = 200
    static let canvasCompletion = 300

    static let colorPoints = 300
    static func getPoints(for: PaintColor) -> Int {
        colorPoints
    }
}

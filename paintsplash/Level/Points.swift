//
//  Points.swift
//  paintsplash
//
//  Created by Ho Pin Xian on 19/3/21.
//

/**
 `Points` calculates the points that are given in the game.
 */
struct Points {
    static let ENEMY_KILL = 100
    static let ENEMY_SPAWNER_KILL = 200
    static let CANVAS_COMPLETION = 100
    static let COLOR_POINTS = 300
    static let CONSECUTIVE_KILL = 200

    /// Returns the number of points for completing the given canvas
    static func scoreCanvas(request: CanvasRequest) -> Int {
        var point = CANVAS_COMPLETION
        point += request.requiredColors.count * COLOR_POINTS
        return point
    }
}

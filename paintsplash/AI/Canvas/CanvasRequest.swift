//
//  CanvasRequests.swift
//  paintsplash
//
//  Created by Cynthia Lee on 17/3/21.
//

class CanvasRequest {
    var requiredColors: Set<PaintColor>

    var reward: Int

    init(requiredColors: Set<PaintColor>, reward: Int) {
        self.requiredColors = requiredColors
        self.reward = reward
    }
}

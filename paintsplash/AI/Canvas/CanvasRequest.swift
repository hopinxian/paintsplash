//
//  CanvasRequests.swift
//  paintsplash
//
//  Created by Cynthia Lee on 17/3/21.
//

class CanvasRequest {
    var requiredColours: Set<PaintColor>

    var reward: Int

    init(requiredColours: Set<PaintColor>, reward: Int) {
        self.requiredColours = requiredColours
        self.reward = reward
    }
}

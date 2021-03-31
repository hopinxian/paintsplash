//
//  ChangeAlphaAnimation.swift
//  paintsplash
//
//  Created by Farrell Nah on 20/3/21.
//
import SpriteKit

class ChangeAlphaAnimation: Animation {
    let newAlpha: Double
    let duration: Double

    init(name: String, duration: Double, newAlpha: Double) {
        self.newAlpha = newAlpha
        self.duration = duration
        super.init(name: name)
    }
    private enum CodingKeys: String, CodingKey {
        case newAlpha, duration
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.newAlpha = try container.decode(Double.self, forKey: .newAlpha)
        self.duration = try container.decode(Double.self, forKey: .duration)
        try super.init(from: container.superDecoder())
    }
    override func getAction() -> SKAction {
        SKAction.fadeAlpha(to: CGFloat(newAlpha), duration: duration)
    }
}

//
//  FadeOutAnimation.swift
//  paintsplash
//
//  Created by Farrell Nah on 20/3/21.
//
import SpriteKit

class FadeOutAnimation: Animation {
    let duration: Double

    init(name: String, duration: Double) {
        self.duration = duration
        super.init(name: name)
    }

    private enum CodingKeys: String, CodingKey {
        case duration
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.duration = try container.decode(Double.self, forKey: .duration)
        try super.init(from: container.superDecoder())
    }
    
    override func getAction() -> SKAction {
        SKAction.fadeOut(withDuration: duration)
    }
}

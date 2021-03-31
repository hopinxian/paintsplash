//
//  SequenceAnimation.swift
//  paintsplash
//
//  Created by Farrell Nah on 20/3/21.
//
import SpriteKit

class SequenceAnimation: Animation {
    let animations: [Animation]

    init(name: String, animations: [Animation]) {
        self.animations = animations
        super.init(name: name)
    }

    private enum Codingkeys: String, CodingKey {
        case animations
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Codingkeys.self)
        self.animations = try container.decode([Animation].self, forKey: .animations)

        try super.init(from: container.superDecoder())
    }

    override func getAction() -> SKAction {
        SKAction.sequence(animations.compactMap({ $0.getAction() }))
    }
}

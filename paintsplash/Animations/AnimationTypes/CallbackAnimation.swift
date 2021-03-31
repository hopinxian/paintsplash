//
//  CallbackAnimation.swift
//  paintsplash
//
//  Created by Farrell Nah on 20/3/21.
//
import SpriteKit

class CallbackAnimation: Animation {
    let animation: Animation
    var completionCallback: (() -> Void)

    init(name: String, animation: Animation, completionCallback: @escaping () -> Void) {
        self.animation = animation
        self.completionCallback = completionCallback
        super.init(name: name)
    }

    override func getAction() -> SKAction {
        SKAction.sequence([animation.getAction(), SKAction.run(completionCallback)])
    }

    private enum CodingKeys: String, CodingKey {
        case animation
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.animation = try container.decode(Animation.self, forKey: .animation)
        self.completionCallback = {}
        try super.init(from: container.superDecoder())
    }

    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(animation, forKey: .animation)
    }
}

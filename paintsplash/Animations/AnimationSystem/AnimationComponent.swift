//
//  AnimationComponent.swift
//  paintsplash
//
//  Created by Farrell Nah on 26/3/21.
//

class AnimationComponent: Component, Codable {
    var currentAnimation: String? {
        didSet {
            wasModified = true
        }
    }
    var animationToPlay: String? {
        didSet {
            wasModified = true
        }
    }
    var animationIsPlaying = false {
        didSet {
            wasModified = true
        }
    }
    var callBack: (() -> Void)? {
        didSet {
            wasModified = true
        }
    }

    override init() {

    }

    func animate(animation: String, interupt: Bool) {
        animate(animation: animation, interupt: interupt, callBack: nil)
    }

    func animate(animation: String, interupt: Bool, callBack: (() -> Void)?) {
        if !animationIsPlaying || interupt {
            self.animationToPlay = animation
            self.callBack = callBack
        }
    }

    private enum CodingKeys: String, CodingKey {
        case currentAnimation, animationToPlay, animationIsPlaying
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.currentAnimation =
            try container.decodeIfPresent(String.self, forKey: .currentAnimation)
        self.animationToPlay =
            try container.decodeIfPresent(String.self, forKey: .animationToPlay)
        self.animationIsPlaying =
            try container.decode(Bool.self, forKey: .animationIsPlaying)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(currentAnimation, forKey: .currentAnimation)
        try container.encodeIfPresent(animationToPlay, forKey: .animationToPlay)
        try container.encode(animationIsPlaying, forKey: .animationIsPlaying)
    }
}

//
//  AnimationP.swift
//  paintsplash
//
//  Created by Farrell Nah on 15/3/21.
//
import SpriteKit

protocol AnimationSource {
    var animations: [String: Animation] { get }
    func getAnimation(from identifier: String) -> Animation?
}

extension AnimationSource {
    func getAnimation(from identifier: String) -> Animation? {
        animations[identifier]
    }
}

class Animation {
    var name: String

    init(name: String) {
        self.name = name
    }

    func getAction() -> SKAction {
        SKAction()
    }
}

extension Animation {
    func equal(to other: Animation) -> Bool {
        self.name == other.name
    }
}

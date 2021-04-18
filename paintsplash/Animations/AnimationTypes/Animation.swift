//
//  Animation.swift
//  paintsplash
//
//  Created by Farrell Nah on 15/3/21.
//
import SpriteKit

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

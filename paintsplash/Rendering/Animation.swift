//
//  AnimationP.swift
//  paintsplash
//
//  Created by Farrell Nah on 15/3/21.
//
import SpriteKit

protocol Animation {
    var name: String { get }
    var animationDuration: Double { get }
    func getAction() -> SKAction
}

extension Animation {
    func equal(to other: Animation) -> Bool {
        self.name == other.name
    }
}

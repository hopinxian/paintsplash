//
//  FadeOutAnimation.swift
//  paintsplash
//
//  Created by Farrell Nah on 20/3/21.
//
import SpriteKit

struct FadeOutAnimation: Animation {
    let name: String
    let animationDuration: Double

    func getAction() -> SKAction {
        SKAction.fadeOut(withDuration: animationDuration)
    }
}

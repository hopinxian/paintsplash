//
//  ChangeAlphaAnimation.swift
//  paintsplash
//
//  Created by Farrell Nah on 20/3/21.
//
import SpriteKit

struct ChangeAlphaAnimation: Animation {
    let name: String
    let animationDuration: Double
    let newAlpha: Double

    func getAction() -> SKAction {
        SKAction.fadeAlpha(to: CGFloat(newAlpha), duration: animationDuration)
    }
}

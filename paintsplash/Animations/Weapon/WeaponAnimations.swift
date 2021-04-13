//
//  WeaponAnimations.swift
//  paintsplash
//
//  Created by Farrell Nah on 19/3/21.
//
import SpriteKit

struct WeaponAnimations: AnimationSource {
    var animations: [String: Animation] = [
        "selectWeapon": RawAnimation(
            name: "selectWeapon",
            action: SKAction.fadeAlpha(to: CGFloat(1), duration: 0.25)
        ),
        "unselectWeapon": RawAnimation(
            name: "unselectWeapon",
            action: SKAction.fadeAlpha(to: CGFloat(0.5), duration: 0.25)
        ),
        "splashFade": RawAnimation(
            name: "splashFade",
            action: SKAction.fadeOut(withDuration: 5)
        )
    ]

    static let selectWeapon = "selectWeapon"
    static let unselectWeapon = "unselectWeapon"
}

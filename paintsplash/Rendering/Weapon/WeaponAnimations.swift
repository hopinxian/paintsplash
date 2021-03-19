//
//  WeaponAnimations.swift
//  paintsplash
//
//  Created by Farrell Nah on 19/3/21.
//

struct WeaponAnimations {
    static let selectWeapon = ChangeAlphaAnimation(name: "selectWeapon", animationDuration: 0.25, newAlpha: 1)
    static let unselectWeapon = ChangeAlphaAnimation(name: "unselectWeapon", animationDuration: 0.25, newAlpha: 0.5)
}

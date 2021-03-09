//
//  UserInput.swift
//  paintsplash
//
//  Created by Farrell Nah on 9/3/21.
//

protocol UserInput {
    func move(in direction: Vector2D)

    func shoot(in direction: Vector2D)

    func changeWeapon(to: Weapon)

    func pause()

    func play()

    func quit()
}

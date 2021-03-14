//
//  UserInput.swift
//  paintsplash
//
//  Created by Farrell Nah on 9/3/21.
//

import Foundation

protocol UserInput {
    func move(in direction: Vector2D)

    func shoot(in direction: Vector2D)

//    func changeWeapon(to: Weapon)

    func pause()

    func play()

    func quit()
}


//
//class JoystickControl: UserInput {
//
//}

class KeyboardControl: InputSystem {
    init() {

    }
}

protocol InputSystem {

}

class Player: InteractiveEntity, Movable {

    var velocity: Vector2D
    var input: InputSystem
    var acceleration: Vector2D

    init(initialPosition: Vector2D, initialVelocity: Vector2D) {
        self.velocity = initialVelocity
        self.acceleration = Vector2D.zero
        self.input = KeyboardControl()

        var transform = Transform.identity
        transform.position = initialPosition

        super.init(spriteName: "", colliderShape: .circle(radius: 50), tags: .player, transform: transform)

        self.currentAnimation = SlimeAnimations.slimeMoveRight
    }

    private func moveTimer() {
//        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
//            self.velocity = Vector2D.up * 50
//            self.move()
//            self.velocity = Vector2D.zero
//        }
    }

    override func update(gameManager: GameManager) {
        move()
//        gameManager.currentPlayerPosition = transform.position
        super.update(gameManager: gameManager)
    }
}

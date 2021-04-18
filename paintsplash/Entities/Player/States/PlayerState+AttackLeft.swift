//
//  PlayerState+AttackLeft.swift
//  paintsplash
//
//  Created by Farrell Nah on 26/3/21.
//

extension PlayerState {
    class AttackLeft: Attack {
        override init(player: Player?, attackDirection: Vector2D) {
            super.init(player: player, attackDirection: attackDirection)
            self.shootAnimation = PlayerAnimations.playerBrushAttackLeft
        }

        override func getCompletionState() -> PlayerState? {
            IdleLeft(player: player)
        }
    }
}

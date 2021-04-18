//
//  PlayerState+MoveRight.swift
//  paintsplash
//
//  Created by Farrell Nah on 26/3/21.
//

extension PlayerState {
    class MoveRight: Move {
        override init(player: Player?) {
            super.init(player: player)
            self.moveAnimation = PlayerAnimations.playerBrushWalkRight
            self.direction = Vector2D.right
        }

        override func getIdleState() -> PlayerState? {
            IdleRight(player: player)
        }

        override func getOppositeState() -> PlayerState? {
            MoveLeft(player: player)
        }
    }
}

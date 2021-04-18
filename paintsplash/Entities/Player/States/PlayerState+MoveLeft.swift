//
//  PlayerState+MoveLeft.swift
//  paintsplash
//
//  Created by Farrell Nah on 26/3/21.
//

extension PlayerState {
    class MoveLeft: Move {
        override init(player: Player?) {
            super.init(player: player)
            self.moveAnimation = PlayerAnimations.playerBrushWalkLeft
            self.direction = Vector2D.left
        }

        override func getIdleState() -> PlayerState? {
            IdleLeft(player: player)
        }

        override func getOppositeState() -> PlayerState? {
            MoveRight(player: player)
        }
    }
}

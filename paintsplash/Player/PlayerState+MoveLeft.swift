//
//  PlayerState+MoveLeft.swift
//  paintsplash
//
//  Created by Farrell Nah on 26/3/21.
//

extension PlayerState {
    class MoveLeft: PlayerState {
        override func onEnterState() {
            player.animationComponent.animate(
                animation: PlayerAnimations.playerBrushWalkLeft,
                interupt: true
            )
        }

        override func getStateTransition() -> State? {
            if player.moveableComponent.direction.magnitude <= 0 {
                return IdleLeft(player: player)
            } else if player.moveableComponent.direction.x > 0 {
                return MoveRight(player: player)
            } else {
                return nil
            }
        }

        override func getBehaviour() -> StateBehaviour {
            MoveBehaviour(
                direction: player.moveableComponent.direction,
                speed: player.moveableComponent.speed
            )
        }
    }
}

//
//  PlayerState+Idle.swift
//  paintsplash
//
//  Created by Farrell Nah on 18/4/21.
//

extension PlayerState {
    class Idle: PlayerState {
        var idleAnimation: String

        override init(player: Player?) {
            idleAnimation = PlayerAnimations.playerBrushIdleLeft
            super.init(player: player)
        }

        convenience init() {
            self.init(player: nil)
        }

        override func onEnterState() {
            player.animationComponent.animate(
                animation: idleAnimation,
                interupt: true
            )
        }

        override func getStateTransition() -> State? {
            if player.moveableComponent.direction.x > 0 {
                return MoveRight(player: player)
            } else if player.moveableComponent.direction.x < 0 {
                return MoveLeft(player: player)
            }

            return nil
        }
    }
}

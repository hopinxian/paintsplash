//
//  PlayerState+IdleLeft.swift
//  paintsplash
//
//  Created by Farrell Nah on 26/3/21.
//
extension PlayerState {
    class IdleLeft: PlayerState {
        convenience init() {
            self.init(player: nil)
        }

        override func onEnterState() {
            player.animationComponent.animate(
                animation: PlayerAnimations.playerBrushIdleLeft,
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

        override func getBehaviour() -> StateBehaviour {
            DoNothingBehaviour()
        }
    }
}

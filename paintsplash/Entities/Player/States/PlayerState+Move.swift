//
//  PlayerState+Move.swift
//  paintsplash
//
//  Created by Farrell Nah on 18/4/21.
//

extension PlayerState {
    class Move: PlayerState {
        var moveAnimation: String
        var direction: Vector2D

        override init(player: Player?) {
            self.moveAnimation = PlayerAnimations.playerBrushWalkLeft
            self.direction = Vector2D.left
            super.init(player: player)
        }

        override func onEnterState() {
            player.animationComponent.animate(
                animation: moveAnimation,
                interupt: true
            )
        }

        override func getStateTransition() -> State? {
            if player.moveableComponent.direction.magnitude <= 0 {
                return getIdleState()
            } else if Vector2D.dot(player.moveableComponent.direction, direction) < 0 {
                return getOppositeState()
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

        func getOppositeState() -> PlayerState? {
            nil
        }

        func getIdleState() -> PlayerState? {
            nil
        }
    }
}

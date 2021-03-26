//
//  PlayerState+Die.swift
//  paintsplash
//
//  Created by Farrell Nah on 26/3/21.
//

extension PlayerState {
    class Die: PlayerState {
        override func onEnterState() {
            player.animationComponent.animate(
                animation: PlayerAnimations.playerDie,
                interupt: true, callBack: { self.player.destroy() }
            )
        }

        override func getStateTransition() -> State? {
            nil
        }

        override func getBehaviour() -> StateBehaviour {
            DoNothingBehaviour()
        }
    }
}

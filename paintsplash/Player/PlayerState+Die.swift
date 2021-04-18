//
//  PlayerState+Die.swift
//  paintsplash
//
//  Created by Farrell Nah on 26/3/21.
//

extension PlayerState {
    class Die: PlayerState {
        override func onEnterState() {
            player.collisionComponent.active = false
            player.moveableComponent.speed = 0.0
            player.animationComponent.animate(
                animation: PlayerAnimations.playerDie,
                interupt: true,
                callBack: { [weak self] in
                    self?.onDieAnimationOver()
                }
            )
        }

        private func onDieAnimationOver() {
            player.destroy()
            EventSystem.gameStateEvents.gameOverEvent.post(event: GameOverEvent(isWin: false))
        }
    }
}

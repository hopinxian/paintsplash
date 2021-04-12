//
//  PlayerState+MoveRight.swift
//  paintsplash
//
//  Created by Farrell Nah on 26/3/21.
//

extension PlayerState {
    class MoveRight: PlayerState {
        override func onEnterState() {
            EventSystem.audioEvent.playSoundEffectEvent.post(
                event: PlaySoundEffectEvent(effect: SoundEffect.playerStep)
            )

            player.animationComponent.animate(animation: PlayerAnimations.playerBrushWalkRight, interupt: true)
        }

        override func onLeaveState() {
            EventSystem.audioEvent.stopSoundEffectEvent.post(
                event: StopSoundEffectEvent()
            )
        }

        override func getStateTransition() -> State? {
            if player.moveableComponent.direction.magnitude <= 0 {
                return IdleRight(player: player)
            } else if player.moveableComponent.direction.x < 0 {
                return MoveLeft(player: player)
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

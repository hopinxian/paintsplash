//
//  PlayerState+AttackLeft.swift
//  paintsplash
//
//  Created by Farrell Nah on 26/3/21.
//

extension PlayerState {
    class AttackLeft: PlayerState {
        var shootComplete = false
        var animationComplete = false
        override func onEnterState() {
            if player.multiWeaponComponent.canShoot() {
                player.animationComponent.animate(
                    animation: PlayerAnimations.playerBrushAttackLeft,
                    interupt: true,
                    callBack: { self.animationComplete = true }
                )
            }
        }

        override func getStateTransition() -> State? {
            if shootComplete && animationComplete {
                return IdleLeft(player: player)
            }

            return nil
        }

        override func getBehaviour() -> StateBehaviour {
            if !shootComplete {
                shootComplete = true
                return ShootProjectileBehaviour()
            }
            return DoNothingBehaviour()
        }
    }
}

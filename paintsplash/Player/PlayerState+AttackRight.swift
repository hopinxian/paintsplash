//
//  PlayerState+AttackRight.swift
//  paintsplash
//
//  Created by Farrell Nah on 26/3/21.
//

extension PlayerState {
    class AttackRight: PlayerState {
        var shootComplete = false
        var animationComplete = false
        override func onEnterState() {
            if player.multiWeaponComponent.canShoot() {
                player.animationComponent.animate(
                    animation: PlayerAnimations.playerBrushAttackRight,
                    interupt: true,
                    callBack: { self.animationComplete = true }
                )
            }
        }

        override func getStateTransition() -> State? {
            if shootComplete && animationComplete {
                return IdleRight(player: player)
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

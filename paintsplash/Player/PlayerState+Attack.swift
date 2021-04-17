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
        var attackDirection: Vector2D

        init(player: Player?, attackDirection: Vector2D) {
            self.attackDirection = attackDirection
            super.init(player: player)
        }

        override func onEnterState() {
            guard !player.isDead else {
                return
            }
            
            if player.multiWeaponComponent.canShoot() {
                player.animationComponent.animate(
                    animation: PlayerAnimations.playerBrushAttackLeft,
                    interupt: true,
                    callBack: { [weak self] in self?.animationComplete = true }
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
                return ShootProjectileBehaviour(shootDirection: attackDirection)
            }
            return DoNothingBehaviour()
        }
    }
}

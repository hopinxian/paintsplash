//
//  PlayerState+Attack.swift
//  paintsplash
//
//  Created by Farrell Nah on 18/4/21.
//

extension PlayerState {
    class Attack: PlayerState {
        var shootComplete = false
        var animationComplete = false
        var attackDirection: Vector2D
        var shootAnimation: String

        init(player: Player?, attackDirection: Vector2D) {
            self.attackDirection = attackDirection
            self.shootAnimation = PlayerAnimations.playerBrushAttackLeft
            super.init(player: player)
        }

        override func onEnterState() {
            guard !player.isDead else {
                return
            }

            if player.multiWeaponComponent.canShoot() {
                player.animationComponent.animate(
                    animation: shootAnimation,
                    interupt: true,
                    callBack: { [weak self] in self?.animationComplete = true }
                )
            }
        }

        override func getStateTransition() -> State? {
            if shootComplete && animationComplete {
                return getCompletionState()
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

        func getCompletionState() -> PlayerState? {
            nil
        }
    }
}

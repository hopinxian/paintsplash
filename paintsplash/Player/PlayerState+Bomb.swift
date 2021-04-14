//
//  PlayerState+Bomb.swift
//  paintsplash
//
//  Created by Farrell Nah on 13/4/21.
//

extension PlayerState {
    class UseBomb: PlayerState {
        var shootComplete = false
        var animationComplete = false
        var attackDirection: Vector2D
        var previousWeapon: Weapon.Type!

        init(player: Player?, attackDirection: Vector2D) {
            self.attackDirection = attackDirection
            super.init(player: player)
            previousWeapon = type(of: self.player.multiWeaponComponent.activeWeapon)
        }

        override func onEnterState() {
            _ = player.multiWeaponComponent.switchWeapon(to: Bomb.self)
            if player.multiWeaponComponent.canShoot() {
                player.animationComponent.animate(
                    animation: PlayerAnimations.playerBrushAttackRight,
                    interupt: true,
                    callBack: { [weak self] in self?.animationComplete = true }
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
                return ShootProjectileBehaviour(shootDirection: attackDirection)
            }
            return DoNothingBehaviour()
        }

        override func onLeaveState() {
            switch previousWeapon {
            case is Bucket.Type:
                _ = player.multiWeaponComponent.switchWeapon(to: Bucket.self)
            case is PaintGun.Type:
                _ = player.multiWeaponComponent.switchWeapon(to: PaintGun.self)
            default:
                break
            }
        }
    }
}

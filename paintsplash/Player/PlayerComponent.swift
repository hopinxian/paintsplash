//
//  PlayerComponent.swift
//  paintsplash
//
//  Created by Farrell Nah on 3/4/21.
//

class PlayableComponent: Component {
    func onMove(event: PlayerMoveEvent) {
        // Do Nothing by Default
    }

    func onShoot(event: PlayerShootEvent) {
        // Do Nothing by Default
    }

    func onWeaponChange(event: PlayerChangeWeaponEvent) {
        // Do Nothing by Default
    }
}

class PlayerComponent: PlayableComponent {
    weak var player: Player?

    override func onMove(event: PlayerMoveEvent) {
        guard let player = player,
              event.playerId == player.id else {
            return
        }

        player.moveableComponent.direction = event.direction

        player.lastDirection = event.direction.magnitude == 0 ? player.lastDirection : event.direction
        let event = PlayerMovementEvent(
            location: player.transformComponent.localPosition,
            playerId: event.playerId
        )
        EventSystem.playerActionEvent.playerMovementEvent.post(event: event)
    }

    override func onShoot(event: PlayerShootEvent) {
        guard let player = player,
              event.playerId == player.id,
              player.multiWeaponComponent.canShoot() else {
            return
        }

        if player.multiWeaponComponent.canShoot() {
            let direction = event.direction.magnitude > 0 ? event.direction : player.lastDirection

            player.stateComponent.currentState = player.lastDirection.x > 0
                ? PlayerState.AttackRight(player: player, attackDirection: direction)
                : PlayerState.AttackLeft(player: player, attackDirection: direction)
        }
    }

    override func onWeaponChange(event: PlayerChangeWeaponEvent) {
        guard let player = player,
              event.playerId == player.id else {
            return
        }
        switch event.newWeapon {
        case is Bucket.Type:
            _ = player.multiWeaponComponent.switchWeapon(to: Bucket.self)
        case is PaintGun.Type:
            _ = player.multiWeaponComponent.switchWeapon(to: PaintGun.self)
        default:
            break
        }

        let weaponChangeEvent = PlayerChangedWeaponEvent(
            weapon: event.newWeapon,
            playerId: player.id
        )

        EventSystem.playerActionEvent.playerChangedWeaponEvent.post(event: weaponChangeEvent)

        let sfxEvent = PlaySoundEffectEvent(effect: SoundEffect.weaponSwap, playerId: player.id)
        EventSystem.audioEvent.playSoundEffectEvent.post(event: sfxEvent)

    }
}

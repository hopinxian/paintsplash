//
//  PlayerComponent.swift
//  paintsplash
//
//  Created by Farrell Nah on 3/4/21.
//

class PlayerComponent: PlayableComponent {
    weak var player: Player!

    override func onMove(event: PlayerMoveEvent) {
        guard event.playerId == player.id else {
            return
        }

        player.moveableComponent.direction = event.direction

        player.lastDirection = event.direction.magnitude == 0 ? player.lastDirection : event.direction

        sendMovementEvent(id: event.playerId)
        if didAmmoChange() {
            updateAimGuide()
        }
    }

    private func sendMovementEvent(id: EntityID) {
        let event = PlayerMovementEvent(
            location: player.transformComponent.localPosition,
            playerId: id
        )
        EventSystem.playerActionEvent.playerMovementEvent.post(event: event)
    }

    private func didAmmoChange() -> Bool {
        guard let currentGuide = player.aimGuide as? Colorable,
              let nextGuide = player.multiWeaponComponent.activeWeapon.getAimGuide() as? Colorable else {
            return false
        }

        return currentGuide.color != nextGuide.color
    }

    override func onAim(event: PlayerAimEvent) {
        guard event.playerId == player.id,
              player.multiWeaponComponent.canShoot() else {
            return
        }

        if player.aimGuide == nil {
            player.aimGuide = player.multiWeaponComponent.getAimGuide()
            player.aimGuide?.spawn()
        }

        player.aimGuide?.aim(at: event.direction)
    }

    override func onShoot(event: PlayerShootEvent) {
        guard event.playerId == player.id,
              player.multiWeaponComponent.canShoot() else {
            return
        }

        attack(direction: event.direction)
        removeAimGuide()
    }

    private func attack(direction: Vector2D) {
        let direction = direction.magnitude > 0 ? direction : player.lastDirection

        let attackState = player.lastDirection.x > 0
            ? PlayerState.AttackRight(player: player, attackDirection: direction)
            : PlayerState.AttackLeft(player: player, attackDirection: direction)

        player.stateComponent.setState(attackState)
    }

    private func removeAimGuide() {
        player.aimGuide?.destroy()
        player.aimGuide = nil
    }

    override func onWeaponChange(event: PlayerChangeWeaponEvent) {
        guard event.playerId == player.id else {
            return
        }

        changeWeapon(to: event.newWeapon)
        sendWeaponChangeEvent(event.newWeapon)
        updateAimGuide()
    }

    private func changeWeapon(to type: Weapon.Type) {
        switch type {
        case is Bucket.Type:
            _ = player.multiWeaponComponent.switchWeapon(to: Bucket.self)
        case is PaintGun.Type:
            _ = player.multiWeaponComponent.switchWeapon(to: PaintGun.self)
        default:
            break
        }
    }

    private func sendWeaponChangeEvent(_ weaponType: Weapon.Type) {
        let weaponChangeEvent = PlayerChangedWeaponEvent(
            weapon: weaponType,
            playerId: player.id
        )

        EventSystem.playerActionEvent.playerChangedWeaponEvent.post(event: weaponChangeEvent)

    }

    private func updateAimGuide() {
        guard let oldGuide = player.aimGuide else {
            return
        }

        let direction = oldGuide.direction
        oldGuide.destroy()
        player.aimGuide = player.multiWeaponComponent.getAimGuide()
        player.aimGuide?.spawn()
        player.aimGuide?.aim(at: direction)
    }
}

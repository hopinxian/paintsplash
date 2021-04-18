//
//  PlayableComponent.swift
//  paintsplash
//
//  Created by Farrell Nah on 17/4/21.
//

/// The base class for a PlayableComponent
class PlayableComponent: Component {
    func onMove(event: PlayerMoveEvent) {
        // Do Nothing by Default
    }

    func onAim(event: PlayerAimEvent) {
        // Do Nothing by Default
    }

    func onShoot(event: PlayerShootEvent) {
        // Do Nothing by Default
    }

    func onWeaponChange(event: PlayerChangeWeaponEvent) {
        // Do Nothing by Default
    }

    func onBomb(event: PlayerBombEvent) {
        // Do Nothing by Default
    }
}

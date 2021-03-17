//
//  PlayerHasShotEvent.swift
//  paintsplash
//
//  Created by Farrell Nah on 16/3/21.
//

struct PlayerAmmoUpdateEvent: Event {
    var weapon: Weapon
    var ammo: [Ammo]
}

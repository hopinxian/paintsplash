//
//  HasWeapon.swift
//  paintsplash
//
//  Created by Farrell Nah on 26/3/21.
//
protocol HasWeapon {
    var weaponComponent: WeaponComponent { get }
    var transformComponent: TransformComponent { get }
}

protocol HasMultiWeapon {
    var multiWeaponComponent: MultiWeaponComponent { get }
    var transformComponent: TransformComponent { get }
}

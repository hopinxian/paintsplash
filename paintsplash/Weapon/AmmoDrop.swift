//
//  AmmoDrop.swift
//  paintsplash
//
//  Created by Ho Pin Xian on 17/3/21.
//

protocol AmmoDrop: Ammo {
    associatedtype AmmoType
    func getAmmoObject() -> AmmoType
}

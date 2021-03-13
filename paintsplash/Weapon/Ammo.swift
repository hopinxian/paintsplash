//
//  Ammo.swift
//  paintsplash
//
//  Created by Farrell Nah on 12/3/21.
//

protocol Ammo {

}

protocol AmmoDrop: Ammo {
    associatedtype AmmoType
    func getAmmoObject() -> AmmoType
}

//
//  Ammo.swift
//  paintsplash
//
//  Created by Farrell Nah on 12/3/21.
//

protocol Ammo {
//    var type: AmmoType { get }
}

enum AmmoType {
    case paint
}

protocol AmmoDrop {
    func getAmmoObject() -> Ammo
}

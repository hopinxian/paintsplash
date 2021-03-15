//
//  PaintAmmo.swift
//  paintsplash
//
//  Created by Farrell Nah on 12/3/21.
//

struct PaintAmmo: Ammo, Colorable {
    var color: PaintColor

    init(color: PaintColor) {
        self.color = color
    }
}

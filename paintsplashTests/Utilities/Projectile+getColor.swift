//
//  Projectile+getColor.swift
//  paintsplashTests
//
//  Created by Ho Pin Xian on 16/3/21.
//

@testable import paintsplash

extension Projectile {
    func getColor() -> PaintColor? {
        if let paintProjectile = self as? PaintProjectile {
            return paintProjectile.color
        }
        return nil
    }
}

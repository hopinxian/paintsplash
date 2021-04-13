//
//  UITouch+Touchable.swift
//  paintsplash
//
//  Created by Praveen Bala on 11/4/21.
//

import SpriteKit

extension UITouch: Touchable {
    func getTouchId() -> EntityID {
        EntityID(id: "TOUCH\(self.hash)")
    }
}

//
//  UITouch+Touchable.swift
//  paintsplash
//
//  Created by Praveen Bala on 11/4/21.
//

import SpriteKit

extension UITouch: TouchData {
    func getTouchId() -> EntityID {
        EntityID(id: "TOUCH\(hash)")
    }

    func getTapCount() -> Int {
        tapCount
    }
}

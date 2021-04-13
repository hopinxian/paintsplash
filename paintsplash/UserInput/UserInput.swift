//
//  UserInput.swift
//  paintsplash
//
//  Created by Farrell Nah on 9/3/21.
//

import CoreGraphics

protocol UserInput {
    func touchDown(atPoint pos: CGPoint, touchable: Touchable)

    func touchMoved(toPoint pos: CGPoint, touchable: Touchable)

    func touchUp(atPoint pos: CGPoint, touchable: Touchable)
}

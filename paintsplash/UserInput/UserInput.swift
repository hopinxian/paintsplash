//
//  UserInput.swift
//  paintsplash
//
//  Created by Farrell Nah on 9/3/21.
//

import Foundation
import CoreGraphics

protocol UserInput {
    func touchDown(atPoint pos : CGPoint)

    func touchMoved(toPoint pos : CGPoint)

    func touchUp(atPoint pos : CGPoint)
}

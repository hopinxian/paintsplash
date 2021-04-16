//
//  UserInput.swift
//  paintsplash
//
//  Created by Farrell Nah on 9/3/21.
//

import CoreGraphics

protocol UserInput {
    func touchDown(event: TouchDownEvent)
    func touchMove(event: TouchMoveEvent)
    func touchUp(event: TouchUpEvent)
}

extension UserInput {
    func touchDown(event: TouchDownEvent) {}
    func touchMove(event: TouchMoveEvent) {}
    func touchUp(event: TouchUpEvent) {}
}

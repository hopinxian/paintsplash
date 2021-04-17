//
//  UserInput.swift
//  paintsplash
//
//  Created by Farrell Nah on 9/3/21.
//

protocol UserInput {
    func touchDown(event: TouchDownEvent)
    func touchMove(event: TouchMoveEvent)
    func touchUp(event: TouchUpEvent)
}

extension UserInput {
    func touchDown(event: TouchDownEvent) {
        // Do nothing by default
    }

    func touchMove(event: TouchMoveEvent) {
        // Do nothing by default
    }

    func touchUp(event: TouchUpEvent) {
        // Do nothing by default
    }
}

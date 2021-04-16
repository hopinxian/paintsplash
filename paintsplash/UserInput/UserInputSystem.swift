//
//  UserInputSystem.swift
//  paintsplash
//
//  Created by Praveen Bala on 6/4/21.
//

protocol UserInputSystem: System {
    func onTouchDown(of touchable: Touchable, at location: Vector2D)
    func onTouchMoved(of touchable: Touchable, at location: Vector2D)
    func onTouchUp(of touchable: Touchable, at location: Vector2D)
}

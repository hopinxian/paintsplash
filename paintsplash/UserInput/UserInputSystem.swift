//
//  UserInputSystem.swift
//  paintsplash
//
//  Created by Praveen Bala on 6/4/21.
//

protocol UserInputSystem: System {
    func touchDown(touchData: TouchData, at location: Vector2D)
    func touchMoved(touchData: TouchData, at location: Vector2D)
    func touchUp(touchData: TouchData, at location: Vector2D)
}

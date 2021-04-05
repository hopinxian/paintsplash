//
//  Touchable.swift
//  paintsplash
//
//  Created by Praveen Bala on 6/4/21.
//

protocol Touchable {
    func touchDown(at point: Vector2D)
    func touchMoved(to point: Vector2D)
    func touchUp(at point: Vector2D)
}

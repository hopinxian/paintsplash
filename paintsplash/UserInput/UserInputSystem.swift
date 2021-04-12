//
//  UserInputSystem.swift
//  paintsplash
//
//  Created by Praveen Bala on 6/4/21.
//

protocol UserInputSystem {
    func addTouchable(_ entity: GameEntity)
    func updateTouchable(_ entity: GameEntity)
    func removeTouchable(_ entity: GameEntity)
}

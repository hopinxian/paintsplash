//
//  EnemyState.swift
//  paintsplash
//
//  Created by Farrell Nah on 26/3/21.
//

class EnemyState: State {
    unowned let enemy: Enemy

    init(enemy: Enemy) {
        self.enemy = enemy
    }
}

//
//  EnemyState.swift
//  paintsplash
//
//  Created by Farrell Nah on 26/3/21.
//

/// The base class for an enemy state.
class EnemyState: State {
    unowned let enemy: Enemy

    init(enemy: Enemy) {
        self.enemy = enemy
    }

    func getRandomState() -> EnemyState? {
        let randomNum = RandomNumber(0).nextInt(-1..<2)
        switch randomNum {
        case 0:
            return nil
        case 1:
            return RandomMovementRight(enemy: enemy)
        case -1:
            return RandomMovementLeft(enemy: enemy)
        default:
            return nil
        }
    }
}

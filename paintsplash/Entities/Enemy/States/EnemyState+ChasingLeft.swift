//
//  EnemyState+ChasingLeft.swift
//  paintsplash
//
//  Created by Farrell Nah on 26/3/21.
//

extension EnemyState {
    class ChasingLeft: Chasing {
        override init(enemy: Enemy) {
            super.init(enemy: enemy)
            self.moveAnimation = SlimeAnimations.slimeMoveLeft
            self.direction = Vector2D.left
        }

        override func getOppositeState() -> EnemyState? {
            ChasingRight(enemy: enemy)
        }
    }
}

//
//  EnemyState+ChasingRight.swift
//  paintsplash
//
//  Created by Farrell Nah on 26/3/21.
//

extension EnemyState {
    class ChasingRight: Chasing {
        override init(enemy: Enemy) {
            super.init(enemy: enemy)
            self.moveAnimation = SlimeAnimations.slimeMoveRight
            self.direction = Vector2D.right
        }

        override func getOppositeState() -> EnemyState? {
            ChasingLeft(enemy: enemy)
        }
    }
}

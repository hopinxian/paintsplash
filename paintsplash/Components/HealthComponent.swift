//
//  HealthComponent.swift
//  paintsplash
//
//  Created by Farrell Nah on 26/3/21.
//

class HealthComponent: Component {
    var currentHealth: Int {
        didSet {
            if currentHealth > maxHealth {
                currentHealth = maxHealth
            }

            if currentHealth < 0 {
                currentHealth = 0
            }
        }
    }

    var maxHealth: Int

    init(currentHealth: Int, maxHealth: Int) {
        self.currentHealth = currentHealth
        self.maxHealth = maxHealth
    }
}

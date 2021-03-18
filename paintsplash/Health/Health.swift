//
//  Health.swift
//  paintsplash
//
//  Created by Farrell Nah on 18/3/21.
//

protocol Health {
    var currentHealth: Int { get }
    var maxHealth: Int { get }

    func heal(amount: Int)

    func takeDamage(amount: Int)
}

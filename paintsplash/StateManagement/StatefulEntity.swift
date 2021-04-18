//
//  AIEntity.swift
//  paintsplash
//
//  Created by Farrell Nah on 26/3/21.
//

/// An entity that can have a state, and changes behaviour based on its state.
protocol StatefulEntity: GameEntity {
    var stateComponent: StateComponent { get }
}

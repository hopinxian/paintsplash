//
//  AIEntity.swift
//  paintsplash
//
//  Created by Farrell Nah on 26/3/21.
//

protocol StatefulEntity: GameEntity {
    var stateComponent: StateComponent { get }
}

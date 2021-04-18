//
//  AIBehaviour.swift
//  paintsplash
//
//  Created by Farrell Nah on 9/3/21.
//

/// A behaviour followed by an entity at every frame, associated with the entity's current state.
protocol StateBehaviour {
    func run(statefulEntity: StatefulEntity, gameInfo: GameInfo)
}

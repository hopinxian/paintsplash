//
//  AISystem.swift
//  paintsplash
//
//  Created by Cynthia Lee on 14/3/21.
//

/// A system that manages entity states, state transitions, and state related behaviours.
protocol StateManagerSystem: System {
    /// The stateful entities being managed by the system.
    var statefulEntities: [EntityID: StatefulEntity] { get set }

    /// Updates all stateful entities being managed by the system.
    func updateEntity(_ entity: EntityID, _ statefulEntity: StatefulEntity)
}

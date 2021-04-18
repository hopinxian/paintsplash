//
//  AIState.swift
//  paintsplash
//
//  Created by Cynthia Lee on 14/3/21.
//
import Foundation

/// The base class for all stateful entity states.
class State {
    /// Determines the next state of the entity, nil if the entity should remain in its current state.
    func getStateTransition() -> State? {
         nil
    }

    /// Gets the behaviour associated with the current state.
    func getBehaviour() -> StateBehaviour {
        DoNothingBehaviour()
    }

    /// Runs custom behaviour that should occur when the entity first enters this state.
    func onEnterState() {
        // Do nothing by default
    }

    /// Runs custom behaviour that should occur when the entity first leaves this state.
    func onLeaveState() {
        // Do nothing by default
    }

    /// Runs custom behaviour that should occur every frame that the entity remains in this state.
    func onStayState() {
        // Do nothing by default
    }
}

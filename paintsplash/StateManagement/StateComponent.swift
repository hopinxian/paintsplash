//
//  AIComponent.swift
//  paintsplash
//
//  Created by Farrell Nah on 26/3/21.
//

class StateComponent: Component {
    var currentState: State

    override init() {
        self.currentState = NoState()
    }

    func getCurrentBehaviour() -> StateBehaviour {
        currentState.getBehaviour()
    }

    func getNextState() -> State? {
        currentState.getStateTransition()
    }

    func setState(_ state: State) {
        currentState.onLeaveState()
        currentState = state
        currentState.onEnterState()
    }
}

//
//  AIComponent.swift
//  paintsplash
//
//  Created by Farrell Nah on 26/3/21.
//

class StateComponent: Component {
    var currentState: State {
        didSet {
            oldValue.onLeaveState()
            currentState.onEnterState()
        }
    }

    override init() {
        self.currentState = NoState()
    }

    func getCurrentBehaviour() -> StateBehaviour {
        currentState.getBehaviour()
    }

    func getNextState() -> State? {
        currentState.getStateTransition()
    }
}

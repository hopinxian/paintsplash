//
//  AIState.swift
//  paintsplash
//
//  Created by Cynthia Lee on 14/3/21.
//
import Foundation

class State {
    func getStateTransition() -> State? {
         nil
    }
    func getBehaviour() -> StateBehaviour {
        DoNothingBehaviour()
    }
    func onEnterState() {
        // Do nothing by default
    }
    func onLeaveState() {
        // Do nothing by default
    }
    func onStayState() {
        // Do nothing by default
        
    }
}

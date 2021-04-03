//
//  StateComponentTests.swift
//  paintsplashTests
//
//  Created by admin on 3/4/21.
//

import XCTest
@testable import paintsplash

class StateComponentTests: XCTestCase {

    var state: EnemyState.ChasingLeft {
        EnemyState.ChasingLeft(enemy: enemy)
    }
    let enemy = Enemy(initialPosition: Vector2D.zero, color: .red)
    let component = StateComponent()

    func testConstruct() {
        XCTAssertTrue(component.currentState is NoState)
        XCTAssertTrue(component.getCurrentBehaviour() is DoNothingBehaviour)
        XCTAssertNil(component.getNextState())
    }
<<<<<<< HEAD
    
=======

>>>>>>> 6ae123731ab4f32a8f8bac44277ef9c93e0a4a67
//    func testGetCurrentBehaviour() {
//        component.currentState = state
//        XCTAssertTrue(component.getCurrentBehaviour() is ChasePlayerBehaviour)
//    }
//
//    func testGetNextState() {
//        component.currentState = state
//        XCTAssertNil(component.getNextState())
//
//        let nextState = EnemyState.Idle(enemy: Enemy(initialPosition: Vector2D.zero, color: .red))
//        component.currentState = nextState
//        XCTAssertTrue(component.getNextState() is EnemyState.ChasingLeft)
//    }
}

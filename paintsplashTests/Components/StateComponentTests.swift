//
//  StateComponentTests.swift
//  paintsplashTests
//
//  Created by admin on 3/4/21.
//

import XCTest
@testable import paintsplash

class StateComponentTests: XCTestCase {

    let state = EnemyState.ChasingLeft(enemy: Enemy(initialPosition: Vector2D.zero, color: .red))
    let component = StateComponent()
    
    override func setUpWithError() throws {
    }

    func testConstruct() {
        XCTAssertTrue(component.currentState is NoState)
        XCTAssertTrue(component.getCurrentBehaviour() is DoNothingBehaviour)
        XCTAssertNil(component.getNextState())
    }
    
    func testGetCurrentBehaviour() {
        component.currentState = state
        XCTAssertTrue(component.getCurrentBehaviour() is ChasePlayerBehaviour)
    }
    
    func testGetNextState() {
        component.currentState = state
        XCTAssertNil(component.getNextState())
        
        let nextState = EnemyState.Idle(enemy: Enemy(initialPosition: Vector2D.zero, color: .red))
        component.currentState = nextState
        XCTAssertTrue(component.getNextState() is EnemyState.ChasingLeft)
    }
}
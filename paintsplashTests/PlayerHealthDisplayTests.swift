//
//  PlayerHealthDisplayTests.swift
//  paintsplashTests
//
//  Created by Cynthia Lee on 3/4/21.
//

import XCTest
@testable import paintsplash

class PlayerHealthDisplayTests: XCTestCase {
    var playerHealthDisplay: PlayerHealthDisplay!
    var player: Player!
    let id = EntityID(id: "id")

    override func setUp() {
        super.setUp()
        self.playerHealthDisplay = PlayerHealthDisplay(startingHealth: 3, associatedEntityId: id)
        self.player = Player(initialPosition: .zero, playerUUID: id)
    }

    override func tearDown() {
        self.playerHealthDisplay = nil
        super.tearDown()
    }

    func testInit() {
        XCTAssertEqual(playerHealthDisplay.healthDisplayView.items.count, 3)
        XCTAssertEqual(playerHealthDisplay.associatedEntity, id)

        let display2 = PlayerHealthDisplay(startingHealth: 1, associatedEntityId: id)
        XCTAssertEqual(display2.healthDisplayView.items.count, 1)
        XCTAssertEqual(display2.associatedEntity, id)

        let display3 = PlayerHealthDisplay(startingHealth: 0, associatedEntityId: id)
        XCTAssertEqual(display3.healthDisplayView.items.count, 0)
        XCTAssertEqual(display3.associatedEntity, id)

        let display4 = PlayerHealthDisplay(startingHealth: -1, associatedEntityId: id)
        XCTAssertEqual(display4.healthDisplayView.items.count, 0)
        XCTAssertEqual(display4.associatedEntity, id)
    }

    func testPlayerHealthUpdate_associatedPlayer() {
        EventSystem.playerActionEvent.playerHealthUpdateEvent
            .post(event: PlayerHealthUpdateEvent(newHealth: 2, playerId: id))
        XCTAssertEqual(playerHealthDisplay.healthDisplayView.items.count, 2)

        EventSystem.playerActionEvent.playerHealthUpdateEvent
            .post(event: PlayerHealthUpdateEvent(newHealth: 0, playerId: id))
        XCTAssertEqual(playerHealthDisplay.healthDisplayView.items.count, 0)

        EventSystem.playerActionEvent.playerHealthUpdateEvent
            .post(event: PlayerHealthUpdateEvent(newHealth: -1, playerId: id))
        XCTAssertEqual(playerHealthDisplay.healthDisplayView.items.count, 0)
    }

    func testPlayerHealthUpdate_differentPlayer() {
        // Test that player health update event for another player id does not update health display view
        let otherPlayerId = EntityID(id: "otherId")
        EventSystem.playerActionEvent.playerHealthUpdateEvent
            .post(event: PlayerHealthUpdateEvent(newHealth: 2, playerId: otherPlayerId))
        XCTAssertEqual(playerHealthDisplay.healthDisplayView.items.count, 3)
    }

}

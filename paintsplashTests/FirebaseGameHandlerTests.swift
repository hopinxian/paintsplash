//
//  FirebaseGameHandlerTests.swift
//  paintsplashTests
//
//  Created by Praveen Bala on 3/4/21.
//

import XCTest
@testable import paintsplash

class FirebaseGameHandlerTests: XCTestCase {

    var connectionHandler: ConnectionHandlerStub!
    var gameHandler: FirebaseGameHandler!

    override func setUp() {
        super.setUp()
        connectionHandler = ConnectionHandlerStub()
        gameHandler = FirebaseGameHandler(connectionHandler: connectionHandler)
    }

    func testSendEventInvalidEventType() {
        sendEvent(CodableEvent(), shouldPass: false)
    }

    func testSendValidEventType() {
        sendEvent(PlayerMoveEvent(direction: .zero, playerID: EntityID()))
        sendEvent(PlayerShootEvent(direction: .zero, playerID: EntityID()))
        sendEvent(PlayerChangeWeaponEvent(newWeapon: Bucket.self, playerId: EntityID()))
        sendEvent(PlayerAmmoUpdateEvent(weaponType: Bucket.self, ammo: [], playerId: EntityID()))
        sendEvent(PlayerHealthUpdateEvent(newHealth: 0, playerId: EntityID()))
        sendEvent(PlaySoundEffectEvent(effect: .attack))
        sendEvent(PlayMusicEvent(music: .backgroundMusic))
    }

    func testObserveInvalidEvent() {
        observeEvent(CodableEvent(), shouldPass: false)
    }

    func testObserveValidEventType() {
        observeEvent(PlayerMoveEvent(direction: .zero, playerID: EntityID()))
        observeEvent(PlayerShootEvent(direction: .zero, playerID: EntityID()))
        observeEvent(PlayerChangeWeaponEvent(newWeapon: Bucket.self, playerId: EntityID()))
        observeEvent(PlayerAmmoUpdateEvent(weaponType: Bucket.self, ammo: [], playerId: EntityID()))
        observeEvent(PlayerHealthUpdateEvent(newHealth: 0, playerId: EntityID()))
        observeEvent(PlaySoundEffectEvent(effect: .attack))
        observeEvent(PlayMusicEvent(music: .backgroundMusic))
    }

    func testAcknowledgeInvalidEvent() {
        acknowledgeEvent(CodableEvent(), shouldPass: false)
    }

    func testAcknowledgeValidEventType() {
        acknowledgeEvent(PlayerMoveEvent(direction: .zero, playerID: EntityID()))
        acknowledgeEvent(PlayerShootEvent(direction: .zero, playerID: EntityID()))
        acknowledgeEvent(PlayerChangeWeaponEvent(newWeapon: Bucket.self, playerId: EntityID()))
        acknowledgeEvent(PlayerAmmoUpdateEvent(weaponType: Bucket.self, ammo: [], playerId: EntityID()))
        acknowledgeEvent(PlayerHealthUpdateEvent(newHealth: 0, playerId: EntityID()))
        acknowledgeEvent(PlaySoundEffectEvent(effect: .attack))
        acknowledgeEvent(PlayMusicEvent(music: .backgroundMusic))
    }

    private func sendEvent<T: Codable>(_ event: T, shouldPass: Bool = true) where T: Event {
        var onSuccessCalled = false
        var onErrorCalled = false

        gameHandler.sendEvent(
            gameId: "0",
            playerId: "0",
            action: event,
            onError: { _ in onErrorCalled = true },
            onSuccess: { onSuccessCalled = true }
        )

        if shouldPass {
            XCTAssertFalse(onErrorCalled)
            XCTAssertTrue(onSuccessCalled)
        } else {
            XCTAssertFalse(onSuccessCalled)
            XCTAssertTrue(onErrorCalled)
        }
    }

    private func observeEvent<T: Codable>(_ event: T, shouldPass: Bool = true) where T: Event {
        var onSuccessCalled = false
        var onErrorCalled = false

        connectionHandler.setListenReturn(event)
        gameHandler.observeEvent(
            gameId: "0",
            playerId: "0",
            onChange: { (_: T) in
                onSuccessCalled = true
            },
            onError: { _ in onErrorCalled = true }
        )

        if shouldPass {
            XCTAssertFalse(onErrorCalled)
            XCTAssertTrue(onSuccessCalled)
        } else {
            XCTAssertFalse(onSuccessCalled)
            XCTAssertTrue(onErrorCalled)
        }
    }

    private func acknowledgeEvent<T: Codable>(_ event: T, shouldPass: Bool = true) where T: Event {
        var onSuccessCalled = false
        var onErrorCalled = false

        if shouldPass {
            connectionHandler.disableErrorOnGet()
        } else {
            connectionHandler.enableErrorOnGet()
        }

        gameHandler.acknowledgeEvent(
            event,
            gameId: "0",
            playerId: "0",
            onError: { _ in onErrorCalled = true },
            onSuccess: { onSuccessCalled = true }
        )

        if shouldPass {
            XCTAssertFalse(onErrorCalled)
            XCTAssertTrue(onSuccessCalled)
        } else {
            XCTAssertFalse(onSuccessCalled)
            XCTAssertTrue(onErrorCalled)
        }
    }
}

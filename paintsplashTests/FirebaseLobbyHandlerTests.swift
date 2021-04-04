//
//  FirebaseLobbyHandlerTests.swift
//  paintsplashTests
//
//  Created by Praveen Bala on 3/4/21.
//

import XCTest
@testable import paintsplash

class FirebaseLobbyHandlerTests: XCTestCase {

    private var connectionHandler: ConnectionHandlerStub!
    private var lobbyHandler: LobbyHandler!
    private let hostPlayer = PlayerInfo(playerUUID: "host", playerName: "hostPlayerName")
    private let clientPlayer = PlayerInfo(playerUUID: "client", playerName: "clientPlayerName")

    override func setUp() {
        super.setUp()
        connectionHandler = ConnectionHandlerStub()
        lobbyHandler = GameLobbyHandler(connectionHandler: connectionHandler)
    }

    func testCreateRoomSuccess() {
        connectionHandler.disableErrorOnGet()

        var onSuccessExecuted = false
        var onFailExecuted = false

        lobbyHandler.createRoom(
            player: hostPlayer,
            onSuccess: { _ in onSuccessExecuted = true },
            onError: { _ in onFailExecuted = true }
        )

        XCTAssertTrue(onSuccessExecuted)
        XCTAssertFalse(onFailExecuted)
    }

    func testCreateRoomFail() {
        connectionHandler.enableErrorOnGet()

        var onSuccessExecuted = false
        var onFailExecuted = false

        lobbyHandler.createRoom(
            player: hostPlayer,
            onSuccess: { _ in onSuccessExecuted = true }, // should not execute
            onError: { _ in onFailExecuted = true } // should execute
        )

        XCTAssertTrue(onFailExecuted)
        XCTAssertFalse(onSuccessExecuted)
    }

    func testCreateRoomDuplicateIDRecreate() {
//        connectionHandler.disableErrorOnGet()
//        let roomDict: [String: Any] = [playerInfo.playerUUID: playerInfo]
//        connectionHandler.setGetObject(roomDict)
//
//        var onSuccessExecuted = false
//        var onFailExecuted = false
//
//        lobbyHandler.createRoom(
//            player: playerInfo,
//            onSuccess: { _ in onSuccessExecuted = true }, // should not execute
//            onError: { _ in onFailExecuted = true } // should execute
//        )
//
//        XCTAssertTrue(onFailExecuted)
//        XCTAssertFalse(onSuccessExecuted)
    }

    func testJoinRoomNotExist() {
        var onSuccessCalled = false
        var onErrorCalled = false
        var onRoomIsClosedCalled = false
        var onRoomNotExistCalled = false

        lobbyHandler.joinRoom(
            player: hostPlayer,
            roomId: "0",
            onSuccess: { _ in onSuccessCalled = true },
            onError: { _ in onErrorCalled = true },
            onRoomIsClosed: { onRoomIsClosedCalled = true },
            onRoomNotExist: { onRoomNotExistCalled = true }
        )

        XCTAssertFalse(onSuccessCalled)
        XCTAssertFalse(onErrorCalled)
        XCTAssertFalse(onRoomIsClosedCalled)
        XCTAssertTrue(onRoomNotExistCalled)
    }

    func testJoinRoomError() {
        var onSuccessCalled = false
        var onErrorCalled = false
        var onRoomIsClosedCalled = false
        var onRoomNotExistCalled = false

        let roomDict: [String: PlayerInfo] = [clientPlayer.playerUUID: hostPlayer]

        let roomInfo = RoomInfo(
            roomId: "0",
            host: hostPlayer,
            players: roomDict,
            isOpen: true
        )

        connectionHandler.setGetObject(roomInfo)
        connectionHandler.enableErrorOnGet()

        lobbyHandler.joinRoom(
            player: hostPlayer,
            roomId: "0",
            onSuccess: { _ in onSuccessCalled = true },
            onError: { _ in onErrorCalled = true },
            onRoomIsClosed: { onRoomIsClosedCalled = true },
            onRoomNotExist: { onRoomNotExistCalled = true }
        )

        XCTAssertFalse(onSuccessCalled)
        XCTAssertFalse(onRoomIsClosedCalled)
        XCTAssertFalse(onRoomNotExistCalled)
        XCTAssertTrue(onErrorCalled)
    }

    func testJoinRoomIsClosed() {
        var onSuccessCalled = false
        var onErrorCalled = false
        var onRoomIsClosedCalled = false
        var onRoomNotExistCalled = false

        let roomInfo = RoomInfo(
            roomId: "0",
            host: hostPlayer,
            players: [String: PlayerInfo](),
            isOpen: false
        )

        connectionHandler.setGetObject(roomInfo)

        lobbyHandler.joinRoom(
            player: hostPlayer,
            roomId: "0",
            onSuccess: { _ in onSuccessCalled = true },
            onError: { _ in onErrorCalled = true },
            onRoomIsClosed: { onRoomIsClosedCalled = true },
            onRoomNotExist: { onRoomNotExistCalled = true }
        )

        XCTAssertFalse(onSuccessCalled)
        XCTAssertFalse(onErrorCalled)
        XCTAssertFalse(onRoomNotExistCalled)
        XCTAssertTrue(onRoomIsClosedCalled)
    }

    func testJoinRoomSuccess() {
        var onSuccessCalled = false
        var onErrorCalled = false
        var onRoomIsClosedCalled = false
        var onRoomNotExistCalled = false

        let roomInfo = RoomInfo(
            roomId: "0",
            host: hostPlayer,
            players: [String: PlayerInfo](),
            isOpen: true
        )

        connectionHandler.setGetObject(roomInfo)

        lobbyHandler.joinRoom(
            player: hostPlayer,
            roomId: "0",
            onSuccess: { _ in onSuccessCalled = true },
            onError: { _ in onErrorCalled = true },
            onRoomIsClosed: { onRoomIsClosedCalled = true },
            onRoomNotExist: { onRoomNotExistCalled = true }
        )

        XCTAssertFalse(onErrorCalled)
        XCTAssertFalse(onRoomNotExistCalled)
        XCTAssertFalse(onRoomIsClosedCalled)
        XCTAssertTrue(onSuccessCalled)
    }

    func testObserveRoomChange() {
        var onRoomChangeCalled = false
        var onRoomCloseCalled = false
        var onErrorCalled = false

        let roomInfo = RoomInfo(
            roomId: "0",
            host: hostPlayer,
            players: [String: PlayerInfo](),
            isOpen: false
        )

        connectionHandler.setListenReturn(roomInfo)

        lobbyHandler.observeRoom(
            roomId: "0",
            onRoomChange: { _ in onRoomChangeCalled = true },
            onRoomClose: { onRoomCloseCalled = true },
            onError: { _ in onErrorCalled = true }
        )

        XCTAssertFalse(onErrorCalled)
        XCTAssertFalse(onRoomCloseCalled)
        XCTAssertTrue(onRoomChangeCalled)
    }

    func testObserveRoomClose() {
        var onRoomChangeCalled = false
        var onRoomCloseCalled = false
        var onErrorCalled = false

        lobbyHandler.observeRoom(
            roomId: "0",
            onRoomChange: { _ in onRoomChangeCalled = true },
            onRoomClose: { onRoomCloseCalled = true },
            onError: { _ in onErrorCalled = true }
        )

        XCTAssertFalse(onErrorCalled)
        XCTAssertFalse(onRoomChangeCalled)
        XCTAssertTrue(onRoomCloseCalled)
    }

    func testLeaveRoomHost() {
        var onSuccessCalled = false
        var onErrorCalled = false

        let roomInfo = RoomInfo(
            roomId: "0",
            host: hostPlayer,
            players: [String: PlayerInfo](),
            isOpen: false
        )

        connectionHandler.setGetObject(roomInfo)
        connectionHandler.disableErrorOnGet()

        lobbyHandler.leaveRoom(
            playerInfo: hostPlayer,
            roomId: "0",
            onSuccess: { onSuccessCalled = true },
            onError: { _ in onErrorCalled = true }
        )

        XCTAssertTrue(onSuccessCalled)
        XCTAssertFalse(onErrorCalled)

        onSuccessCalled = false
        onErrorCalled = false

        connectionHandler.enableErrorOnGet()

        lobbyHandler.leaveRoom(
            playerInfo: hostPlayer,
            roomId: "0",
            onSuccess: { onSuccessCalled = true },
            onError: { _ in onErrorCalled = true }
        )

        XCTAssertFalse(onSuccessCalled)
        XCTAssertTrue(onErrorCalled)
    }

    func testLeaveRoomGuest() {
        var onSuccessCalled = false
        var onErrorCalled = false

        let roomInfo = RoomInfo(
            roomId: "0",
            host: hostPlayer,
            players: [String: PlayerInfo](),
            isOpen: false
        )

        connectionHandler.setGetObject(roomInfo)
        connectionHandler.disableErrorOnGet()

        lobbyHandler.leaveRoom(
            playerInfo: clientPlayer,
            roomId: "0",
            onSuccess: { onSuccessCalled = true },
            onError: { _ in onErrorCalled = true }
        )

        XCTAssertTrue(onSuccessCalled)
        XCTAssertFalse(onErrorCalled)

        onSuccessCalled = false
        onErrorCalled = false

        connectionHandler.enableErrorOnGet()

        lobbyHandler.leaveRoom(
            playerInfo: clientPlayer,
            roomId: "0",
            onSuccess: { onSuccessCalled = true },
            onError: { _ in onErrorCalled = true }
        )

        XCTAssertFalse(onSuccessCalled)
        XCTAssertTrue(onErrorCalled)
    }

    func testLeaveNonExistentRoom() {
        var onSuccessCalled = false
        var onErrorCalled = false

        connectionHandler.disableErrorOnGet()

        lobbyHandler.leaveRoom(
            playerInfo: clientPlayer,
            roomId: "0",
            onSuccess: { onSuccessCalled = true },
            onError: { _ in onErrorCalled = true }
        )

        XCTAssertFalse(onSuccessCalled)
        XCTAssertTrue(onErrorCalled)
    }

    func testStartGameConditions() {
        let roomDict: [String: PlayerInfo] = [clientPlayer.playerUUID: clientPlayer]

        let roomInfo: [RoomInfo?] =
            [nil, RoomInfo(roomId: "0", host: clientPlayer, players: roomDict, isOpen: true)]

        for room in roomInfo {
            var onSuccessCalled = false
            var onErrorCalled = false

            connectionHandler.setGetObject(room)

            lobbyHandler.startGame(
                roomId: "0",
                player: hostPlayer,
                onSuccess: { _ in onSuccessCalled = true },
                onError: { _ in onErrorCalled = true }
            )

            XCTAssertFalse(onSuccessCalled)
            XCTAssertFalse(onErrorCalled)
        }
    }

    func testStartGame() {
        var onSuccessCalled = false
        var onErrorCalled = false

        let roomDict: [String: PlayerInfo] = [clientPlayer.playerUUID: clientPlayer]
        let room = RoomInfo(roomId: "0", host: hostPlayer, players: roomDict, isOpen: true)

        connectionHandler.setGetObject(room)
        connectionHandler.enableErrorOnGet()

        lobbyHandler.startGame(
            roomId: "0",
            player: hostPlayer,
            onSuccess: { _ in onSuccessCalled = true },
            onError: { _ in onErrorCalled = true }
        )

        XCTAssertFalse(onSuccessCalled)
        XCTAssertTrue(onErrorCalled)

        onSuccessCalled = false
        onErrorCalled = false

        connectionHandler.disableErrorOnGet()

        lobbyHandler.startGame(
            roomId: "0",
            player: hostPlayer,
            onSuccess: { _ in onSuccessCalled = true },
            onError: { _ in onErrorCalled = true }
        )

        XCTAssertTrue(onSuccessCalled)
        XCTAssertFalse(onErrorCalled)
    }

    func testStopGame() {
        let roomDict: [String: PlayerInfo] = [clientPlayer.playerUUID: clientPlayer]
        let room = RoomInfo(roomId: "0", host: hostPlayer, players: roomDict, isOpen: true)

        var onSuccessCalled = false
        var onErrorCalled = false

        connectionHandler.disableErrorOnGet()

        lobbyHandler.stopGame(
            roomInfo: room,
            onSuccess: { onSuccessCalled = true },
            onError: { _ in onErrorCalled = true }
        )

        XCTAssertTrue(onSuccessCalled)
        XCTAssertFalse(onErrorCalled)

        onSuccessCalled = false
        onErrorCalled = true

        connectionHandler.enableErrorOnGet()

        lobbyHandler.stopGame(
            roomInfo: room,
            onSuccess: { onSuccessCalled = true },
            onError: { _ in onErrorCalled = true }
        )

        XCTAssertFalse(onSuccessCalled)
        XCTAssertTrue(onErrorCalled)
    }

    func testObserveGame() {
        var onGameStopCalled = false
        var onErrorCalled = false

        let roomDict: [String: PlayerInfo] = [clientPlayer.playerUUID: clientPlayer]
        let room = RoomInfo(roomId: "0", host: hostPlayer, players: roomDict, isOpen: true)

        connectionHandler.setGetObject(false)

        lobbyHandler.observeGame(
            roomInfo: room,
            onGameStop: { onGameStopCalled = true },
            onError: { _ in onErrorCalled = true }
        )

        XCTAssertFalse(onErrorCalled)
        XCTAssertTrue(onGameStopCalled)
    }
}

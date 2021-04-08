//
//  MultiplayerServerViewController.swift
//  paintsplash
//
//  Created by Farrell Nah on 29/3/21.
//
import UIKit
import SpriteKit

class MultiplayerServerViewController: UIViewController, GameViewController {
    var lobbyHandler: LobbyHandler!
    var roomInfo: RoomInfo!

    @IBOutlet private var gameView: SKView!

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let scene = gameView.scene as? GameScene else {
            fatalError("Game Scene not setup properly")
        }
        let gameManager = MultiplayerServer(roomInfo: roomInfo, gameScene: scene, vc: self)
        scene.gameManager = gameManager

        // set up observer for game state
        lobbyHandler.observeGame(roomInfo: roomInfo, onGameStop: { [weak self] in self?.closeGameWindow() },
                                 onError: nil)

        gameView.ignoresSiblingOrder = true

        gameView.showsFPS = true
        gameView.showsNodeCount = true

        // set up observer for room
        lobbyHandler?.observeRoom(
            roomId: roomInfo.roomId,
            onRoomChange: { [weak self] in self?.handleRoomChange(roomInfo: $0) },
            onRoomClose: { [weak self] in self?.closeGameWindow() },
            onError: nil
        )
    }

    private func handleRoomChange(roomInfo: RoomInfo) {
        if roomInfo.players == nil {
            closeGameWindow()
        }
    }

    @IBAction private func endMultplayerGame(_ sender: UIButton) {
        closeGame()
    }

    func closeGame() {
        lobbyHandler.stopGame(roomInfo: self.roomInfo, onSuccess: nil, onError: nil)
    }

    func closeGameWindow() {
        self.navigationController?.popViewController(animated: true)
    }

    deinit {
        print("Deinitialized MultiplayerServerVC")
    }
}

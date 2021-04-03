//
//  MultiplayerServerViewController.swift
//  paintsplash
//
//  Created by Farrell Nah on 29/3/21.
//
import UIKit
import SpriteKit

class MultiplayerServerViewController: UIViewController {
    var lobbyHandler: LobbyHandler!
    var roomInfo: RoomInfo!

    @IBOutlet var gameView: SKView!

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let scene = gameView.scene as? GameScene else {
            fatalError()
        }
        let gameManager = MultiplayerServer(roomInfo: roomInfo, gameScene: scene)
        scene.gameManager = gameManager

        // set up observer for game state
        lobbyHandler.observeGame(roomInfo: roomInfo, onGameStop: { [weak self] in self?.onCloseGame() },
                                 onError: nil)

        // set up observer for room
        lobbyHandler?.observeRoom(roomId: roomInfo.roomId,
                                  onRoomChange: { [weak self] in self?.handleRoomChange(roomInfo: $0) },
                                  onRoomClose: { [weak self] in self?.onCloseGame() },
                                  onError: nil)
    }

    private func handleRoomChange(roomInfo: RoomInfo) {
        if roomInfo.players == nil {
            onCloseGame()
        }
    }

    @IBAction private func endMultplayerGame(_ sender: UIButton) {
        lobbyHandler.stopGame(roomInfo: self.roomInfo, onSuccess: nil, onError: nil)
    }

    private func onCloseGame() {
        print("closing server game")
        self.navigationController?.popViewController(animated: true)
    }

    deinit {
        print("Deinitialized MultiplayerServerVC")
    }
}

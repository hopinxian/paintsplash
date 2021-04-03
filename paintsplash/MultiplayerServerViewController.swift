//
//  MultiplayerServerViewController.swift
//  paintsplash
//
//  Created by Farrell Nah on 29/3/21.
//
import UIKit
import SpriteKit

class MultiplayerServerViewController: GameViewController {
    weak var lobbyHandler: LobbyHandler?
    var roomInfo: RoomInfo!

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let scene = self.gameScene else {
            fatalError("GameScene not setup properly")
        }
        let gameManager = MultiplayerServer(roomInfo: roomInfo, gameScene: scene)
        scene.gameManager = gameManager

        // set up observer for game state
        lobbyHandler?.observeGame(roomInfo: roomInfo, onGameStop: onCloseGame, onError: nil)
    }

    @IBAction private func endMultplayerGame(_ sender: UIButton) {
        lobbyHandler?.stopGame(roomInfo: self.roomInfo, onSuccess: nil, onError: nil)
    }

    private func onCloseGame() {
        print("closing server game")
        self.navigationController?.popViewController(animated: true)
        self.navigationController?.popViewController(animated: true)
    }

    deinit {
        print("Deinitialized MultiplayerServerVC")
    }
}

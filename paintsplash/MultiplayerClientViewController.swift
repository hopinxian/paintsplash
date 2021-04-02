//
//  MultiplayerClientViewController.swift
//  paintsplash
//
//  Created by Farrell Nah on 29/3/21.
//
import UIKit

class MultiplayerClientViewController: GameViewController {
    var connectionHandler: ConnectionHandler!
    var playerInfo: PlayerInfo?
    var roomInfo: RoomInfo?

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let scene = gameScene else {
            fatalError("GameScene not setup properly")
        }

        guard let playerInfo = self.playerInfo,
              let roomInfo = self.roomInfo else {
            return
        }
        let gameManager = MultiplayerClient(gameScene: scene,
                                            playerInfo: playerInfo,
                                            roomInfo: roomInfo)
        scene.gameManager = gameManager
    }

    @IBAction private func endMultiplayerGame(_ sender: UIButton) {
    }

    deinit {
        print("closed multiplayer client VC")
    }
}

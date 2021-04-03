//
//  MultiplayerClientViewController.swift
//  paintsplash
//
//  Created by Farrell Nah on 29/3/21.
//
import UIKit

class MultiplayerClientViewController: GameViewController {
    var lobbyHandler: LobbyHandler!
    var playerInfo: PlayerInfo!
    var roomInfo: RoomInfo!

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let scene = gameScene else {
            fatalError("GameScene not setup properly")
        }

        guard let playerInfo = self.playerInfo,
              let roomInfo = self.roomInfo else {
            return
        }
        let gameManager = MultiplayerClient(
            gameScene: scene,
            playerInfo: playerInfo,
            roomInfo: roomInfo
        )
        scene.gameManager = gameManager

        lobbyHandler.observeGame(
            roomInfo: roomInfo,
            onGameStop: onCloseGame,
            onError: { error in
                print("Error observing game on client")
            }
        )
    }

    @IBAction private func endMultiplayerGame(_ sender: UIButton) {
        lobbyHandler.stopGame(roomInfo: self.roomInfo, onSuccess: nil, onError: nil)
    }

    private func onCloseGame() {
        print("closing multiplayer game")
        self.navigationController?.popViewController(animated: true)
    }

    deinit {
        print("closed multiplayer client VC")
    }
}

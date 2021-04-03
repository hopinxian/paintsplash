//
//  MultiplayerClientViewController.swift
//  paintsplash
//
//  Created by Farrell Nah on 29/3/21.
//
import UIKit
import SpriteKit

class MultiplayerClientViewController: UIViewController {
    weak var lobbyHandler: LobbyHandler?
    var playerInfo: PlayerInfo!
    var roomInfo: RoomInfo!

    @IBOutlet var gameView: SKView!

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let scene = gameView.scene as? GameScene else {
            fatalError("Game scene not setup properly")
        }

        let gameManager = MultiplayerClient(
            gameScene: scene,
            playerInfo: playerInfo,
            roomInfo: roomInfo
        )
        scene.gameManager = gameManager

        lobbyHandler?.observeGame(roomInfo: roomInfo,
                                  onGameStop: onCloseGame,
                                  onError: { print("Error observing game on client: \($0)") })
    }

    @IBAction private func endMultiplayerGame(_ sender: UIButton) {
        lobbyHandler?.stopGame(roomInfo: self.roomInfo, onSuccess: nil, onError: nil)
    }

    private func onCloseGame() {
        print("closing client multiplayer game")
        self.navigationController?.popViewController(animated: true)
    }

    deinit {
        print("Deinit MultiplayerClientVC")
    }
}

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

    @IBOutlet private var gameView: SKView!

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

        lobbyHandler?.observeGame(
            roomInfo: roomInfo,
            onGameStop: { [weak self] in self?.onCloseGame() },
            onError: onError
        )

        gameView.ignoresSiblingOrder = true

        gameView.showsFPS = true
        gameView.showsNodeCount = true

        // Observe room: If host quits, close the game
        lobbyHandler?.observeRoom(
            roomId: roomInfo.roomId,
            onRoomChange: nil,
            onRoomClose: { [weak self] in self?.onCloseGame() },
            onError: nil
        )
    }

    private func onError(error: Error?) {
        if let err = error {
            print("Error observing game on client: \(err)")
        }
    }

    @IBAction private func endMultiplayerGame(_ sender: UIButton) {
        lobbyHandler?.stopGame(roomInfo: self.roomInfo, onSuccess: nil, onError: nil)
    }

    private func onCloseGame() {
        self.navigationController?.popViewController(animated: true)
    }

    deinit {
        print("Deinit MultiplayerClientVC")
    }
}

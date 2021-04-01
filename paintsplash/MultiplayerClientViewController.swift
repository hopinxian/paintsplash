//
//  MultiplayerClientViewController.swift
//  paintsplash
//
//  Created by Farrell Nah on 29/3/21.
//

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
        let gameManager = MultiplayerClient(room: roomInfo,
                                            gameScene: scene,
                                            playerInfo: playerInfo)
        scene.gameManager = gameManager
    }
}

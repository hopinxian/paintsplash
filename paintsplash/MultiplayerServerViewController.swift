//
//  MultiplayerServerViewController.swift
//  paintsplash
//
//  Created by Farrell Nah on 29/3/21.
//

class MultiplayerServerViewController: GameViewController {
    var connectionHandler: ConnectionHandler!
    var lobbyHandler: LobbyHandler!
    var roomInfo: RoomInfo!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let scene = gameScene else {
            fatalError("GameScene not setup properly")
        }
        let gameManager = MultiplayerServer(lobbyHandler: lobbyHandler, roomInfo: roomInfo)
        scene.gameManager = gameManager
    }
}

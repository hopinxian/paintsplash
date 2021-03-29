//
//  MultiplayerClientViewController.swift
//  paintsplash
//
//  Created by Farrell Nah on 29/3/21.
//

class MultiplayerClientViewController: GameViewController {
    var connectionHandler: ConnectionHandler!
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let scene = gameScene else {
            fatalError("GameScene not setup properly")
        }
        let gameManager = MultiplayerClient(connectionHandler: connectionHandler, gameScene: scene)
        scene.gameManager = gameManager
    }
}

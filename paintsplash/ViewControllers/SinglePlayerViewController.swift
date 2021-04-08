//
//  SinglePlayerViewController.swift
//  paintsplash
//
//  Created by Farrell Nah on 29/3/21.
//
import UIKit
import SpriteKit

class SinglePlayerViewController: UIViewController, GameViewController {
    @IBOutlet private var gameView: SKView!

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let gameScene = gameView.scene as? GameScene else {
            fatalError("GameScene not setup properly")
        }
        let gameManager = SinglePlayerGameManager(gameScene: gameScene, vc: self)
        gameScene.gameManager = gameManager

        gameView.ignoresSiblingOrder = true

        gameView.showsFPS = true
        gameView.showsNodeCount = true
    }

    @IBAction private func onCloseGame(_ sender: UIButton) {
        closeGame()
    }

    func closeGame() {
        self.navigationController?.popViewController(animated: true)
    }

    deinit {
        print("deinit SinglePlayerViewController")
    }
}

//
//  GameViewController.swift
//  paintsplash
//
//  Created by Praveen Bala on 8/3/21.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            guard let gameScene = SKScene(fileNamed: "GameScene") as? GameScene else {
                return
            }

            // Set the scale mode to scale to fit the window
            gameScene.scaleMode = .aspectFill

            // Present the scene
            view.presentScene(gameScene)

            let gameManager = GameManager(gameScene: gameScene)
            gameScene.gameManager = gameManager

            view.ignoresSiblingOrder = true

            view.showsFPS = true
            view.showsNodeCount = true
        }
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}

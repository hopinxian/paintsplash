//
//  GameViewController.swift
//  paintsplash
//
//  Created by Praveen Bala on 8/3/21.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {
    weak var gameScene: GameScene?
    weak var gameManager: GameManager?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // swiftlint:disable force_cast
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            guard let gameScene = SKScene(fileNamed: "GameScene") as? GameScene else {
                return
            }

            self.gameScene = gameScene

            // Set the scale mode to scale to fit the window
            gameScene.scaleMode = .aspectFill

            // Present the scene
            gameScene.size = view.bounds.size
            view.preferredFramesPerSecond = 60

            view.presentScene(gameScene)

            view.ignoresSiblingOrder = true

            view.showsFPS = true
            view.showsNodeCount = true
        }
    }

    @IBAction private func closeGame(_ sender: Any) {
        self.gameScene = nil

        self.removeFromParent()

        self.dismiss(animated: true, completion: nil)

        if let view = self.view as? SKView? {
            view?.presentScene(nil)
        }

    }

    override var shouldAutorotate: Bool {
        true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        true
    }

    deinit {
        print("deinit game view controller")
    }
}

//
//  SinglePlayerViewController.swift
//  paintsplash
//
//  Created by Farrell Nah on 29/3/21.
//
import UIKit

class SinglePlayerViewController: GameViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let scene = gameScene else {
            fatalError("GameScene not setup properly")
        }
        let gameManager = SinglePlayerGameManager(gameScene: scene)
        gameScene?.gameManager = gameManager
    }
    @IBAction func onCloseGame(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

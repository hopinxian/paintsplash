//
//  MenuViewController.swift
//  paintsplash
//
//  Created by Cynthia Lee on 27/3/21.
//

import UIKit

class MenuViewController: UIViewController {

    @IBOutlet private var startGameButton: UIButton!

//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "StartGameSegue" {
//            if let gameViewController = segue.destination as? GameViewController {
//                gameViewController.modalPresentationStyle = .fullScreen
//            }
//        }
//    }
    @IBAction func onStartGame(_ sender: UIButton) {
        let singlePlayerVC = SinglePlayerViewController()
        navigationController?.pushViewController(singlePlayerVC, animated: true)
    }
}

//
//  MenuViewController.swift
//  paintsplash
//
//  Created by Cynthia Lee on 27/3/21.
//

import UIKit

class MenuViewController: UIViewController {
    @IBAction func startSinglePlayer(_ sender: UIButton) {
        guard let viewController = UIStoryboard(name: "Main", bundle: nil)
                .instantiateViewController(identifier: ViewControllerIdentifiers.singlePlayer)
                as? SinglePlayerViewController else {
            fatalError("Error creating client view controller")
        }
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

//
//  MenuViewController.swift
//  paintsplash
//
//  Created by Cynthia Lee on 27/3/21.
//

import UIKit

class MenuViewController: UIViewController {
    @IBAction private func startSinglePlayer(_ sender: UIButton) {
        let uiViewController = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(identifier: ViewControllerIdentifiers.singlePlayer)
        guard let viewController = uiViewController as? SinglePlayerViewController else {
            fatalError("Error creating client view controller")
        }

        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

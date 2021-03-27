//
//  MultiplayerMenuViewController.swift
//  paintsplash
//
//  Created by Cynthia Lee on 27/3/21.
//

import UIKit

class MultiplayerMenuViewController: UIViewController {
    let connectionHandler = FirebaseConnectionHandler()

    @IBOutlet private var nameTextField: UITextField!

    @IBOutlet private var createRoomButton: UIButton!
    @IBOutlet private var joinRoomButton: UIButton!

    override func viewDidLoad() {
        toggleButtons(enabled: false)
    }

    @IBAction private func didNameTextFieldChange(_ sender: UITextField) {

        guard let name = nameTextField.text else {
            return
        }

        toggleButtons(enabled: !name.isEmpty)
    }

    private func toggleButtons(enabled: Bool) {
        createRoomButton.isEnabled = enabled
        joinRoomButton.isEnabled = enabled
    }

    @IBAction func createRoom(_ sender: Any) {
        guard let name = nameTextField.text else {
            return
        }
        connectionHandler.createRoom(hostName: name)
    }


}

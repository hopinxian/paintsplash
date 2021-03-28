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

    private var roomId: String?

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

    @IBAction private func createRoom(_ sender: UIButton) {
        guard let name = nameTextField.text else {
            return
        }

        // Show loading animation
        connectionHandler.createRoom(hostName: name,
                                     onSuccess: { roomId in
                                        self.onCreateRoom(roomId: roomId)
                                     },
                                     onError: { error in print("Failed to host room: \(error)") })
    }

    private func onCreateRoom(roomId: String) {
        // Close loading animation

        print("created room with id: \(roomId)")
        self.roomId = roomId
        connectionHandler.getAllRooms()

        performSegue(withIdentifier: "ShowRoomVCSegue", sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "ShowRoomVCSegue":
            guard let roomVC = segue.destination as? RoomViewController,
                  let roomId = self.roomId else {
                return
            }
            roomVC.roomId = roomId
        default:
            print("No segue with given identifier")
            return
        }

    }


}

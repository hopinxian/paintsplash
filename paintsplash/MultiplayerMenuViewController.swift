//
//  MultiplayerMenuViewController.swift
//  paintsplash
//
//  Created by Cynthia Lee on 27/3/21.
//

import UIKit

class MultiplayerMenuViewController: UIViewController {
    let connectionHandler: ConnectionHandler = FirebaseConnectionHandler()

    @IBOutlet private var nameTextField: UITextField!

    @IBOutlet private var createRoomButton: UIButton!
    @IBOutlet private var joinRoomButton: UIButton!

    private var roomId: String?
    private var playerName = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        toggleButtons(enabled: false)
    }

    @IBAction private func didNameTextFieldChange(_ sender: UITextField) {

        guard let name = nameTextField.text else {
            return
        }

        toggleButtons(enabled: !name.isEmpty)
        self.playerName = name
    }

    private func toggleButtons(enabled: Bool) {
        createRoomButton.isEnabled = enabled
        joinRoomButton.isEnabled = enabled
    }

    @IBAction private func createRoom(_ sender: UIButton) {
        guard let name = nameTextField.text else {
            return
        }

        connectionHandler.createRoom(hostName: name,
                                     onSuccess: { roomInfo in
                                        self.onCreateRoom(roomInfo: roomInfo)
                                     },
                                     onError: { error in print("Failed to host room: \(error)") })
    }

    private func onCreateRoom(roomInfo: RoomInfo) {
        self.roomId = roomInfo.roomId
        self.playerName = roomInfo.hostName ?? ""
        connectionHandler.getAllRooms()

        performSegue(withIdentifier: SegueIdentifiers.roomVCSegue, sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case SegueIdentifiers.roomVCSegue:
            guard let roomVC = segue.destination as? RoomViewController,
                  let roomId = self.roomId else {
                return
            }
            roomVC.roomId = roomId
            roomVC.hostName = self.playerName
            roomVC.connectionHandler = self.connectionHandler

        case SegueIdentifiers.joinRoomVCSegue:
            guard let joinRoomVC = segue.destination as? JoinRoomViewController else {
                return
            }
            joinRoomVC.playerName = self.playerName
            joinRoomVC.connectionHandler = self.connectionHandler
        default:
            print("No segue with given identifier")
            return
        }

    }

}

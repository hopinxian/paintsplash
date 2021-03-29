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

    private var currentRoom: RoomInfo?
    private var playerName = String()
    private let playerUUID = UUID().uuidString

    override func viewDidLoad() {
        super.viewDidLoad()
        toggleButtons(enabled: false)
    }

    @IBAction private func didNameTextFieldChange(_ sender: UITextField) {
        guard let name = nameTextField.text else {
            return
        }

        self.playerName = name

        toggleButtons(enabled: !name.isEmpty)
    }

    private func toggleButtons(enabled: Bool) {
        createRoomButton.isEnabled = enabled
        joinRoomButton.isEnabled = enabled
    }

    @IBAction private func createRoom(_ sender: UIButton) {
        let playerInfo = PlayerInfo(uuid: self.playerUUID, name: self.playerName, isHost: true)
        connectionHandler.createRoom(player: playerInfo,
                                     onSuccess: { roomInfo in
                                        self.onCreateRoom(roomInfo: roomInfo)
                                     },
                                     onError: { error in print("Failed to host room: \(error)") })
    }

    private func onCreateRoom(roomInfo: RoomInfo) {
        self.currentRoom = roomInfo
        connectionHandler.getAllRooms()

        performSegue(withIdentifier: SegueIdentifiers.roomVCSegue, sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case SegueIdentifiers.roomVCSegue:
            // TODO: when creating a room
            guard let roomVC = segue.destination as? RoomViewController,
                  let currentRoom = self.currentRoom else {
                return
            }
            roomVC.currentRoom = currentRoom
            roomVC.playerInfo = PlayerInfo(uuid: self.playerUUID,
                                           name: self.playerName,
                                           isHost: true)
            roomVC.connectionHandler = self.connectionHandler

        case SegueIdentifiers.joinRoomVCSegue:
            guard let joinRoomVC = segue.destination as? JoinRoomViewController else {
                return
            }
            joinRoomVC.playerInfo = PlayerInfo(uuid: self.playerUUID,
                                           name: self.playerName,
                                           isHost: false)
            joinRoomVC.connectionHandler = self.connectionHandler
        default:
            print("No segue with given identifier")
            return
        }

    }

}

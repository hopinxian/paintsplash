//
//  MultiplayerMenuViewController.swift
//  paintsplash
//
//  Created by Cynthia Lee on 27/3/21.
//

import UIKit

class MultiplayerMenuViewController: UIViewController {
    let lobbyHandler: LobbyHandler

    @IBOutlet private var nameTextField: UITextField!

    @IBOutlet private var createRoomButton: UIButton!
    @IBOutlet private var joinRoomButton: UIButton!

    private var currentRoom: RoomInfo?
    private var playerName = String()
    private let playerUUID = UUID().uuidString

    required init?(coder: NSCoder) {
        let connectionHandler = FirebaseConnectionHandler()
        lobbyHandler = GameLobbyHandler(connectionHandler: connectionHandler)
        super.init(coder: coder)
    }

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
        let playerInfo = PlayerInfo(playerUUID: self.playerUUID, playerName: self.playerName)
        lobbyHandler.createRoom(
            player: playerInfo,
            onSuccess: { roomInfo in
                self.onCreateRoom(roomInfo: roomInfo)
            },
            onError: onError
        )
    }

    private func onError(error: Error?) {
        if let err = error {
            print("Failed to host room: \(err)")
        }
    }

    private func onCreateRoom(roomInfo: RoomInfo) {
        self.currentRoom = roomInfo
        lobbyHandler.getAllRooms()

        performSegue(withIdentifier: SegueIdentifiers.multiplayerMenuToRoom, sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case SegueIdentifiers.multiplayerMenuToRoom:
            // TODO: when creating a room
            guard let roomVC = segue.destination as? RoomViewController,
                  let currentRoom = self.currentRoom else {
                return
            }

            roomVC.currentRoom = currentRoom
            roomVC.playerInfo = PlayerInfo(
                playerUUID: self.playerUUID,
                playerName: self.playerName
            )
            roomVC.lobbyHandler = self.lobbyHandler

        case SegueIdentifiers.joinRoomVCSegue:
            guard let joinRoomVC = segue.destination as? JoinRoomViewController else {
                return
            }

            joinRoomVC.playerInfo = PlayerInfo(
                playerUUID: self.playerUUID,
                playerName: self.playerName
            )

            joinRoomVC.lobbyHandler = self.lobbyHandler
        default:
            print("No segue with given identifier")
            return
        }
    }

    @IBAction private func closeMultiplayerMenu(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    deinit {
        print("Closed multiplayer menu")
    }

}

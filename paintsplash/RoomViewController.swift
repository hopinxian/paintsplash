//
//  RoomViewController.swift
//  paintsplash
//
//  Created by Cynthia Lee on 28/3/21.
//

import UIKit

class RoomViewController: UIViewController {

    @IBOutlet private var roomCodeDisplay: UILabel!
    @IBOutlet private var hostNameLabel: UILabel!
    @IBOutlet private var guestNameLabel: UILabel!
    @IBOutlet var startGameButton: UIButton!

    var currentRoom: RoomInfo? {
        didSet {
            guard let roomInfo = currentRoom else {
                return
            }
            onRoomChange(roomInfo: roomInfo)
        }
    }

    var playerInfo: PlayerInfo?

    var lobbyHandler: LobbyHandler?

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let room = self.currentRoom else {
            return
        }

        lobbyHandler?.observeRoom(roomId: room.roomId,
                                       onRoomChange: onRoomChange,
                                       onRoomClose: onRoomClose,
                                       onError: onError)
        onRoomChange(roomInfo: room)
        if playerInfo != currentRoom?.host {
            startGameButton.isEnabled = false
        }
    }

    func onRoomChange(roomInfo: RoomInfo) {
        // print("on room change triggered: guest: \(roomInfo.players?.first?.playerName)")
        self.roomCodeDisplay?.text = roomInfo.roomId
        self.hostNameLabel?.text = roomInfo.host.playerName
        self.guestNameLabel?.text = roomInfo.players?.first?.value.playerName
    }

    func onRoomClose() {
        print("on room close")
    }

    func onError(error: Error?) {
        print("Error encountered")
    }

    @IBAction private func leaveRoom(_ sender: UIButton) {

    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "StartMultiplayerServer":
            guard let serverVC = segue.destination as? MultiplayerServerViewController else {
                return
            }

            serverVC.lobbyHandler = self.lobbyHandler
            serverVC.connectionHandler = FirebaseConnectionHandler()
            serverVC.roomInfo = currentRoom
        default:
            break
        }
    }

}

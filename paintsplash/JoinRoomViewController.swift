//
//  JoinRoomViewController.swift
//  paintsplash
//
//  Created by Cynthia Lee on 28/3/21.
//

import UIKit

class JoinRoomViewController: UIViewController {
    var lobbyHandler: LobbyHandler?

    var roomToJoin: RoomInfo?

    var playerInfo: PlayerInfo?
//    var playerUUID = String()
//    var playerName = String()

    @IBOutlet private var enterRoomIdTextField: UITextField!

    @IBAction private func didChangeRoomIdTextField(_ sender: UITextField) {
        // TODO: check input for numbers only (tbc)
        // TODO: disable button join button if empty
    }

    @IBAction private func joinRoom(_ sender: Any) {
        guard let roomIdToJoin = enterRoomIdTextField.text,
              !roomIdToJoin.isEmpty,
              let player = playerInfo else {
            return
        }
        lobbyHandler?.joinRoom(player: player,
                                    roomId: roomIdToJoin,
                                    onSuccess: onJoinRoom,
                                    onError: onErrorJoiningRoom,
                                    onRoomIsClosed: onRoomIsClosed,
                                    onRoomNotExist: onRoomNotExist)
    }

    func onErrorJoiningRoom(error: Error?) {
        print("Error joining room")
    }

    func onJoinRoom(roomInfo: RoomInfo) {
        print("successfully joined room: transitioning")
        // TODO: reset to nil when room VC is closed
        self.roomToJoin = roomInfo
        performSegue(withIdentifier: SegueIdentifiers.joinMenuToRoom, sender: nil)
    }

    func onRoomNotExist() {
        print("Room with code does not exist")
    }

    func onRoomIsClosed() {
        print("Room is closed")
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case SegueIdentifiers.joinMenuToRoom:
            guard let roomVC = segue.destination as? RoomViewController,
                  let roomInfo = self.roomToJoin else {
                return
            }
            roomVC.currentRoom = roomInfo
            roomVC.playerInfo = self.playerInfo
            roomVC.lobbyHandler = self.lobbyHandler
        case "StartMultiplayerClient":
            guard let clientVC = segue.destination as? MultiplayerClientViewController else {
                return
            }

            clientVC.connectionHandler = FirebaseConnectionHandler()
        default:
            print("No segue with given identifier")
            return
        }

    }
}

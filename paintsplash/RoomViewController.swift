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

    var currentRoom: RoomInfo?

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
        print("onRoomChange: \(roomInfo)")
        self.currentRoom = roomInfo

        self.roomCodeDisplay?.text = roomInfo.roomId
        self.hostNameLabel?.text = roomInfo.host.playerName
        self.guestNameLabel?.text = roomInfo.players?.first?.value.playerName

        if roomInfo.started {
            if roomInfo.host == playerInfo {
                performSegue(withIdentifier: "StartMultiplayerServer", sender: nil)
            } else {
                performSegue(withIdentifier: "StartMultiplayerClient", sender: nil)
            }
        }
    }

    func onRoomClose() {
        print("on room close")
    }

    func onError(error: Error?) {
        print("Error encountered: \(error)")
    }

    @IBAction private func startGame(_ sender: UIButton) {
        print("start game button pressed")
        guard let roomInfo = self.currentRoom,
              let player = self.playerInfo else {
            return
        }

        lobbyHandler?.startGame(roomId: roomInfo.roomId, player: player,
                                onSuccess: nil, onError: onError(error:))

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
            serverVC.roomInfo = currentRoom
        case "StartMultiplayerClient":
            guard let clientVC = segue.destination as? MultiplayerClientViewController else {
                return
            }
            clientVC.connectionHandler = FirebaseConnectionHandler()
            clientVC.roomInfo = self.currentRoom
            clientVC.playerInfo = self.playerInfo
        default:
            break
        }
    }

}

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
    @IBOutlet private var startGameButton: UIButton!

    var currentRoom: RoomInfo?

    var playerInfo: PlayerInfo?

    var lobbyHandler: LobbyHandler?

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let room = self.currentRoom else {
            return
        }

        lobbyHandler?.observeRoom(
            roomId: room.roomId,
            onRoomChange: onRoomChange,
            onRoomClose: onRoomClose,
            onError: onError
        )

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
            guard roomInfo.players != nil else {
                return
            }
            if roomInfo.host == playerInfo {
                startServer()
            } else {
                startClient()
            }
        }
    }

    private func startServer() {
        guard let serverVC = UIStoryboard(name: "Main", bundle: nil)
                .instantiateViewController(identifier: ViewControllerIdentifiers.multiplayerServer)
            as? MultiplayerServerViewController else {
                fatalError("Error creating server view controller")
            }

        serverVC.lobbyHandler = self.lobbyHandler
        serverVC.roomInfo = currentRoom
        self.navigationController?.pushViewController(serverVC, animated: true)
    }

    private func startClient() {
        guard let clientVC = UIStoryboard(name: "Main", bundle: nil)
                .instantiateViewController(identifier: ViewControllerIdentifiers.multiplayerClient)
                as? MultiplayerClientViewController else {
            fatalError("Error creating client view controller")
        }
        clientVC.roomInfo = self.currentRoom
        clientVC.playerInfo = self.playerInfo
        clientVC.lobbyHandler = self.lobbyHandler
        self.navigationController?.pushViewController(clientVC, animated: true)
    }

    func onRoomClose() {
        print("on room close")
        self.navigationController?.popViewController(animated: true)
    }

    func onError(error: Error?) {
        if let err = error {
            print("Error encountered: \(err)")
        }
    }

    @IBAction private func startGame(_ sender: UIButton) {
        guard let roomInfo = self.currentRoom,
              let player = self.playerInfo else {
            return
        }

        lobbyHandler?.startGame(
            roomId: roomInfo.roomId,
            player: player,
            onSuccess: nil,
            onError: onError
        )
    }

    @IBAction private func leaveRoom(_ sender: UIButton) {
        guard let roomInfo = self.currentRoom,
              let player = self.playerInfo else {
            return
        }
        lobbyHandler?.leaveRoom(
            playerInfo: player,
            roomId: roomInfo.roomId,
            onSuccess: onRoomClose,
            onError: onError
        )
    }

    deinit {
        print("Closed view controller")
    }

}

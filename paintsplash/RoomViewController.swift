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

    var currentRoom: RoomInfo? {
        didSet {
            guard let roomInfo = currentRoom else {
                return
            }
            onRoomChange(roomInfo: roomInfo)
        }
    }

    var playerInfo: PlayerInfo?

    var connectionHandler: ConnectionHandler?

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let room = self.currentRoom else {
            return
        }

        connectionHandler?.observeRoom(roomId: room.roomId,
                                       onRoomChange: onRoomChange,
                                       onRoomClose: onRoomClose,
                                       onError: onError)
    }

    func onRoomChange(roomInfo: RoomInfo) {
        print("Room changed!")
        self.roomCodeDisplay?.text = roomInfo.roomId
        self.hostNameLabel?.text = roomInfo.hostName
        self.guestNameLabel?.text = roomInfo.guestName
    }

    func onRoomClose() {

    }

    func onError() {
        print("Error encountered")
    }

    @IBAction private func leaveRoom(_ sender: UIButton) {

    }

}

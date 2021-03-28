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

    var roomId = String()
    var hostName = String()
    var guestName = String()
    var connectionHandler: ConnectionHandler?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.roomCodeDisplay?.text = roomId
        self.hostNameLabel?.text = hostName
        self.guestNameLabel?.text = guestName

        connectionHandler?.observeRoom(roomId: roomId,
                                       onRoomChange: onRoomChange,
                                       onRoomClose: onRoomClose,
                                       onError: onError)
    }

    func onRoomChange(roomInfo: RoomInfo) {
        print("Room changed!")
        self.hostNameLabel.text = roomInfo.hostName
        self.guestNameLabel.text = roomInfo.guestName
    }

    func onRoomClose() {

    }

    func onError() {
        print("Error encountered")
    }

}

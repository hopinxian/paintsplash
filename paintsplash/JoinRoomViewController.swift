//
//  JoinRoomViewController.swift
//  paintsplash
//
//  Created by Cynthia Lee on 28/3/21.
//

import UIKit

class JoinRoomViewController: UIViewController {
    // private var roomIdToJoin = String()
    var playerName = String()
    var connectionHandler: ConnectionHandler?

    @IBOutlet private var enterRoomIdTextField: UITextField!

    @IBAction private func didChangeRoomIdTextField(_ sender: UITextField) {
        // TODO: check input for numbers only (tbc)
        // TODO: disable button join button if empty
    }

    @IBAction private func joinRoom(_ sender: Any) {
        guard let roomIdToJoin = enterRoomIdTextField.text,
              !roomIdToJoin.isEmpty else {
            return
        }

        connectionHandler?.joinRoom(guestName: self.playerName,
                                    roomId: roomIdToJoin,
                                    onSuccess: onJoinRoom,
                                    onError: onErrorJoiningRoom,
                                    onRoomIsClosed: onRoomIsClosed,
                                    onRoomNotExist: onRoomNotExist)
    }

    func onErrorJoiningRoom() {
        print("Error joining room")
    }

    func onJoinRoom(roomInfo: RoomInfo) {
//        let roomVC = RoomViewController()
//        roomVC.roomId = roomInfo.roomId
//        roomVC.hostName = roomInfo.hostName ?? ""
//        roomVC.guestName = roomInfo.guestName ?? ""

        //self.present(roomVC, animated: true, completion: nil)

        performSegue(withIdentifier: SegueIdentifiers.roomVCSegue, sender: roomInfo)
    }

    func onRoomNotExist() {
        print("Room with code does not exist")
    }

    func onRoomIsClosed() {
        print("Room is closed")
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case SegueIdentifiers.roomVCSegue:
            guard let roomVC = segue.destination as? RoomViewController,
                  let roomInfo = sender as? RoomInfo else {
                return
            }
            roomVC.roomId = roomInfo.roomId
            roomVC.hostName = roomInfo.hostName ?? ""
            roomVC.guestName = roomInfo.guestName ?? ""
        default:
            print("No segue with given identifier")
            return
        }

    }
}

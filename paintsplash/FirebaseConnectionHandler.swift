//
//  FirebaseConnectionHandler.swift
//  paintsplash
//
//  Created by Cynthia Lee on 27/3/21.
//

import Firebase

class FirebaseConnectionHandler: ConnectionHandler {
    var databaseRef = Database.database().reference()

    func createRoom(hostName: String) {
        databaseRef.child(FirebasePaths.rooms).child(hostName).setValue(["isOpen": true])
        getAllRooms()
    }

    func joinRoom(hostName: String) {
    }

    func getAllRooms() {
        databaseRef.child(FirebasePaths.rooms).getData(completion: { (error, snapshot) in
            if let error = error {
                print("Error fetching all rooms \(error)")
                return
            }
            print("Fetched all rooms: \(snapshot)")

        })
    }
}

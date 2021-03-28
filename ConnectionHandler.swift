//
//  ConnectionHandler.swift
//  paintsplash
//
//  Created by Farrell Nah on 28/3/21.
//

protocol ConnectionHandler {
    func send(to destination: CloudPath, data: [String: Any])
    func listen(to source: CloudPath, callBack: @escaping ([String: Any]) -> Void)
}

import Firebase

class FirebaseConnectionHandler: ConnectionHandler {
    var firebase: Database

    init(firebase: Database) {
        self.firebase = firebase
    }

    func send(to destination: CloudPath, data: [String: Any]) {
        firebase.reference().child(destination.path).setValue(data)
    }

    func listen(to source: CloudPath, callBack: @escaping ([String: Any]) -> Void) {
        firebase.reference().child(source.path).observe(DataEventType.value) { snapshot in
            let dataDict = snapshot.value as? [String: AnyObject] ?? [:]
            callBack(dataDict)
        }
    }
}

protocol CloudPath {
    var path: String { get }
    static func fromObject(_ object: AnyObject) -> CloudPath
}

class FirebasePath: CloudPath {
    static func fromObject(_ object: AnyObject) -> CloudPath {
        switch object {
        case let lobby as MultiplayerLobby:
            let id = lobby.id
            return FirebasePath(path: id.uuidString)
        case let entity as GameEntity:
            let id = entity.id
            return FirebasePath(path: id.uuidString)
        default:
            return FirebasePath(path: "")
        }
    }

    var path: String

    init(path: String) {
        self.path = path
    }
}

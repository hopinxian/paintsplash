//
//  ConnectionHandler.swift
//  paintsplash
//
//  Created by Farrell Nah on 28/3/21.
//

protocol ConnectionHandler {
    func send<T: Codable>(to destination: CloudPath, data: T, mode: TransactionMode) throws
    func listen<T: Codable>(to source: CloudPath, callBack: @escaping (T) -> Void)
}

import Firebase

class FirebaseConnectionHandler: ConnectionHandler {
    var firebase: Database
    var batchedOperations = [FirebaseOperation]()

    init(firebase: Database) {
        self.firebase = firebase
    }

    func send<T: Codable>(to destination: CloudPath, data: T, mode: TransactionMode = .single) throws {
        guard let dataDict = data.dictionary else {
            throw FirebaseError.encodingError
        }

        if mode == .single {
            firebase.reference().child(destination.path).setValue(dataDict)
        } else if mode == .batched {
            batchedOperations.append(FirebaseOperation(path: destination.path, data: dataDict))
        }
    }

    func listen<T: Codable>(to source: CloudPath, callBack: @escaping (T) -> Void) {
        firebase.reference().child(source.path).observe(DataEventType.value) { snapshot in
            let dataDict = snapshot.value as? [String: AnyObject] ?? [:]
            if let object = T.init(from: dataDict) {
                callBack(object)
            }
        }
    }

    func commitBatchedOperations() {
        guard !batchedOperations.isEmpty else {
            return
        }

        firebase.reference().runTransactionBlock({ mutableData in
            for operation in self.batchedOperations {
                mutableData.childData(byAppendingPath: operation.path).value = operation.data
            }

            return TransactionResult.success(withValue: mutableData)
        })
    }
}

enum TransactionMode {
    case single
    case batched
}

struct FirebaseOperation {
    let path: String
    let data: [String: Any]
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

extension Encodable {
  var dictionary: [String: Any]? {
    guard let data = try? JSONEncoder().encode(self) else { return nil }
    return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
  }
}

extension Decodable {
  init?(from: Any) {
    do {
        let data = try JSONSerialization.data(withJSONObject: from, options: .prettyPrinted)
        let decoder = JSONDecoder()
        self = try decoder.decode(Self.self, from: data)
    } catch {
        return nil
    }
  }
}

enum FirebaseError: Error {
    case encodingError
}

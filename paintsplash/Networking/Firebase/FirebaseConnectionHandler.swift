//
//  FirebaseConnectionHandler.swift
//  paintsplash
//
//  Created by Farrell Nah on 3/4/21.
//
import Firebase

class FirebaseConnectionHandler: ConnectionHandler {
    var firebase: Database
    var batchedOperations = [FirebaseOperation]()
    private var observers: [FirebaseObserver] = []

    deinit {
        print("Deinitializing FirebaseConnectionHandler")
        // detach all observers
        observers.forEach { observer in
            observer.reference.removeObserver(withHandle: observer.handle)
        }
    }

    init() {
        self.firebase =
            Database.database(url: "http://localhost:9000/?ns=paintsplash-fe2d8")
    }

    func send<T: Codable>(
        to destination: String,
        data: T,
        mode: TransactionMode,
        shouldRemoveOnDisconnect: Bool,
        onComplete: (() -> Void)?,
        onError: ((Error?) -> Void)?
    ) {
        let dataDict = data.dictionary

        if mode == .single {
            firebase.reference().child(destination).setValue(dataDict, withCompletionBlock: { error, ref in
                if shouldRemoveOnDisconnect {
                    ref.onDisconnectRemoveValue()
                }
                if error != nil {
                    DispatchQueue.main.async {
                        onError?(error)
                    }
                } else {
                    DispatchQueue.main.async {
                        onComplete?()
                    }
                }
            })
        } else if mode == .batched {
            batchedOperations.append(
                FirebaseOperation(
                    path: destination, data: dataDict,
                    onSuccess: onComplete, onError: onError)
            )
        }
    }

    func listen<T: Codable>(to source: String, callBack: @escaping (T?) -> Void) {
        let ref = firebase.reference().child(source)
        let observerHandle = ref.observe(DataEventType.value) { snapshot in
            let rawData = snapshot.value as? [String: AnyObject] ?? [:]
            let data = T(from: rawData)
            callBack(data)
        }
        self.observers.append(FirebaseObserver(handle: observerHandle, reference: ref))
    }

    func getData<T: Codable>(at path: String, block: @escaping (Error?, T?) -> Void) {
        firebase.reference().child(path).getData(completion: { error, snapshot in
            // TODO Error Handling
            let rawData = snapshot.value as? [String: AnyObject] ?? [:]
            let data = T(from: rawData)
            block(error, data)
        })
    }

    func getData(at path: String, block: @escaping (Error?, [String: Any]?) -> Void) {
        firebase.reference().child(path).getData(completion: { error, snapshot in
            let rawData = snapshot.value as? [String: AnyObject]
            block(error, rawData)
        })
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
        }, andCompletionBlock: { error, success, _ in
            if success {
                for operation in self.batchedOperations {
                    DispatchQueue.main.async {
                        operation.onSuccess?()
                    }
                }
            } else {
                for operation in self.batchedOperations {
                    DispatchQueue.main.async {
                        operation.onError?(error)
                    }
                }
            }
        })
    }

    func removeData(at path: String, block: @escaping (Error?) -> Void) {
        firebase.reference().child(path).removeValue(completionBlock: { error, _ in
            block(error)
        })
    }

    func sendSingleValue<T: Codable>(
        to path: String, data: T,
        shouldRemoveOnDisconnect: Bool,
        onComplete: (() -> Void)?,
        onError: ((Error?) -> Void)?
    ) {
        firebase.reference().child(path).setValue(data, withCompletionBlock: { error, ref in
            if shouldRemoveOnDisconnect {
                ref.onDisconnectRemoveValue()
            }
            if error != nil {
                DispatchQueue.main.async {
                    onError?(error)
                }
            } else {
                DispatchQueue.main.async {
                    onComplete?()
                }
            }
        })
    }

    func observeSingleValue<T: Codable>(to source: String, callBack: @escaping (T?) -> Void) {
        let ref = firebase.reference().child(source)
        let observerHandle = ref.observe(DataEventType.value) { snapshot in
            let rawData = snapshot.value as? T
            callBack(rawData)
        }
        self.observers.append(FirebaseObserver(handle: observerHandle, reference: ref))
    }
}

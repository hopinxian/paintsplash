//
//  FirebaseConnectionHandler.swift
//  paintsplash
//
//  Created by Farrell Nah on 3/4/21.

import Firebase

class FirebaseConnectionHandler: ConnectionHandler {
    var firebase: Database
    private var observers: [FirebaseObserver] = []

    init() {
        // Uncomment to use Firebase Emulator (development)
        self.firebase =
            Database.database(url: "http://localhost:9000/?ns=paintsplash-fe2d8")

        // Uncomment to use Firebase Real Time Database (production)
        // self.firebase = Database.database()
    }

    /// Writes the given data dictionary to the path in the Firebase Real Time database,
    /// - Parameters:
    ///   - shouldRemoveOnDisconnect: indicates if the written value at the path
    ///    should be deleted from the database when disconnected
    ///   - onComplete: callback invoked when data is successfully written
    ///   - onError: callback invoked when error encountered
    func send<T: Codable>(
        to destination: String,
        data: T,
        shouldRemoveOnDisconnect: Bool = true,
        onComplete: (() -> Void)?,
        onError: ((Error?) -> Void)?) {

        let dataDict = data.dictionary
        let operation = FirebaseOperation(path: destination, data: dataDict, onSuccess: onComplete, onError: onError)

        handleSingleWriteOperation(operation: operation, shouldRemoveOnDisconnect: shouldRemoveOnDisconnect)
    }

    /// Writes the given individual data valueto the path in the Firebase Real Time database
    func sendSingleValue<T: Codable>(
        to path: String,
        data: T,
        shouldRemoveOnDisconnect: Bool,
        onComplete: (() -> Void)?,
        onError: ((Error?) -> Void)?
    ) {
        let operation = FirebaseOperation(path: path, data: data, onSuccess: onComplete, onError: onError)
        handleSingleWriteOperation(operation: operation, shouldRemoveOnDisconnect: shouldRemoveOnDisconnect)
    }

    private func handleSingleWriteOperation(operation: FirebaseOperation, shouldRemoveOnDisconnect: Bool) {
        let path = operation.path
        let dataDict = operation.data
        let onComplete = operation.onSuccess
        let onError = operation.onError

        firebase.reference().child(path).setValue(dataDict, withCompletionBlock: { error, ref in
            if shouldRemoveOnDisconnect {
                ref.onDisconnectRemoveValue()
            }

            guard error == nil else {
                DispatchQueue.main.async {
                    onError?(error)
                }
                return
            }

            DispatchQueue.main.async {
                onComplete?()
            }
        })
    }

    /// Observes a dictionary value at the given path, and invokes the callback when the value changes
    func listen<T: Codable>(to source: String, callBack: @escaping (T?) -> Void) {
        let ref = firebase.reference().child(source)
        let observerHandle = ref.observe(DataEventType.value) { snapshot in
            let rawData = snapshot.value as? [String: AnyObject] ?? [:]
            let data = T(from: rawData)
            callBack(data)
        }

        // Keep track of the listener and database reference to be
        // removed later during deinitialization
        self.observers.append(FirebaseObserver(handle: observerHandle, reference: ref))
    }

    /// Observes a raw Codable value at the given path, and invokes the callback when the value changes
    func listenToSingleValue<T: Codable>(to source: String, callBack: @escaping (T?) -> Void) {
        let ref = firebase.reference().child(source)
        let observerHandle = ref.observe(DataEventType.value) { snapshot in
            let rawData = snapshot.value as? T
            callBack(rawData)
        }
        self.observers.append(FirebaseObserver(handle: observerHandle, reference: ref))
    }

    /// Fetches data as a Codable from given path and invokes the given callback
    func getData<T: Codable>(at path: String, callback: @escaping (Error?, T?) -> Void) {
        firebase.reference().child(path).getData(completion: { error, snapshot in
            let rawData = snapshot.value as? [String: AnyObject] ?? [:]
            let data = T(from: rawData)
            callback(error, data)
        })
    }

    /// Fetches data as a dictionary from given path and invokes the given callback
    func getData(at path: String, block: @escaping (Error?, [String: Any]?) -> Void) {
        firebase.reference().child(path).getData(completion: { error, snapshot in
            let rawData = snapshot.value as? [String: AnyObject]
            block(error, rawData)
        })
    }

    /// Erases data at the given path and invokes the given callback
    func removeData(at path: String, callBack: @escaping (Error?) -> Void) {
        firebase.reference().child(path).removeValue(completionBlock: { error, _ in
            callBack(error)
        })
    }

    /// Removes all callbacks on Firebase listeners
    private func detachObservers() {
        observers.forEach { observer in
            observer.reference.removeObserver(withHandle: observer.handle)
        }
    }

    deinit {
        print("Deinitializing FirebaseConnectionHandler")
        detachObservers()
    }
}

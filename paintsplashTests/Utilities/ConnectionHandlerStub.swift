//
//  ConnectionHandlerStub.swift
//  paintsplashTests
//
//  Created by Praveen Bala on 3/4/21.
// swiftlint:disable function_parameter_count

import Foundation
@testable import paintsplash

class ConnectionHandlerStub: ConnectionHandler {

    private var error: Error?
    private var getObject: Any?
    private var listen: Any?

    func enableErrorOnGet() {
        error = ErrorStub.error
    }

    func disableErrorOnGet() {
        error = nil
    }

    func setGetObject(_ object: Any) {
        getObject = object
    }

    func removeGetObject() {
        getObject = nil
    }

    func setListenReturn(_ object: Any) {
        listen = object
    }

    func removeListenReturn() {
        listen = nil
    }

    func send<T>(to destination: String,
                 data: T,
                 mode: TransactionMode,
                 shouldRemoveOnDisconnect: Bool,
                 onComplete: (() -> Void)?,
                 onError: ((Error?) -> Void)?) where T: Decodable, T: Encodable {
        guard error == nil else {
            onError?(ErrorStub.error)
            return
        }
        onComplete?()
    }

    func listen<T>(to source: String,
                   callBack: @escaping (T?) -> Void) where T: Decodable, T: Encodable {
        callBack((listen as? T))
    }

    func getData<T>(at path: String,
                    callback: @escaping (Error?, T?) -> Void) where T: Decodable, T: Encodable {
        callback(error, (getObject as? T))
    }

    func getData(at path: String,
                 block: @escaping (Error?, [String: Any]?) -> Void) {
        block(error, (getObject as? [String: Any]))
    }

    func removeData(at path: String,
                    block: @escaping (Error?) -> Void) {
        block(error)
    }

    func sendSingleValue<T>(to path: String,
                            data: T,
                            shouldRemoveOnDisconnect: Bool,
                            onComplete: (() -> Void)?,
                            onError: ((Error?) -> Void)?) where T: Decodable, T: Encodable {

        guard error == nil else {
            onError?(ErrorStub.error)
            return
        }
        onComplete?()
    }

    func observeSingleValue<T>(to source: String, callBack: @escaping (T?) -> Void) where T: Decodable, T: Encodable {
        callBack((getObject as? T))
    }
}

enum ErrorStub: Error {
    case error
}

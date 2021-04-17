//
//  ConnectionHandler.swift
//  paintsplash
//
//  Created by Farrell Nah on 28/3/21.

protocol ConnectionHandler {
    func send<T: Codable>(
        to destination: String,
        data: T,
        shouldRemoveOnDisconnect: Bool,
        onComplete: (() -> Void)?,
        onError: ((Error?) -> Void)?
    )
    func sendSingleValue<T: Codable>(
        to path: String,
        data: T,
        shouldRemoveOnDisconnect: Bool,
        onComplete: (() -> Void)?,
        onError: ((Error?) -> Void)?
    )

    func listen<T: Codable>(to source: String, callBack: @escaping (T?) -> Void)
    func listenToSingleValue<T: Codable>(to source: String, callBack: @escaping (T?) -> Void)

    func getData<T: Codable>(at path: String, callback: @escaping (Error?, T?) -> Void)
    func getData(at path: String, block: @escaping (Error?, [String: Any]?) -> Void)
    func removeData(at path: String, callBack: @escaping (Error?) -> Void)
}

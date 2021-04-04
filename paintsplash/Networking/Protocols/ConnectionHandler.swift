//
//  ConnectionHandler.swift
//  paintsplash
//
//  Created by Farrell Nah on 28/3/21.
// swiftlint:disable function_parameter_count

protocol ConnectionHandler {
    func send<T: Codable>(
        to destination: String,
        data: T,
        mode: TransactionMode,
        shouldRemoveOnDisconnect: Bool,
        onComplete: (() -> Void)?,
        onError: ((Error?) -> Void)?
    )
    func listen<T: Codable>(to source: String, callBack: @escaping (T?) -> Void)
    func getData<T: Codable>(at path: String, block: @escaping (Error?, T?) -> Void)
    func getData(at path: String, block: @escaping (Error?, [String: Any]?) -> Void)
    func removeData(at path: String, block: @escaping (Error?) -> Void)

    // methods for individual value
    func sendSingleValue<T: Codable>(
        to path: String, data: T,
        shouldRemoveOnDisconnect: Bool,
        onComplete: (() -> Void)?,
        onError: ((Error?) -> Void)?
    )
    func observeSingleValue<T: Codable>(
        to source: String,
        callBack: @escaping (T?) -> Void
    )
}

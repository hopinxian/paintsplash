//
//  ClientCallback.swift
//  paintsplash
//
//  Created by admin on 1/4/21.
//

import Foundation

class ClientCallback {
    var callbacks: [CallbackId: (() -> Void)]
    
    private init() {
        callbacks = [:]
    }
    
    static let manager = ClientCallback()
    
    func startCallback(of id: CallbackId) {
        if let callback = callbacks[id] {
            callback()
            callbacks[id] = nil
        }
    }
    
    func addCallback(callback: @escaping (() -> Void)) -> CallbackId {
        let id = CallbackId(callbackId: UUID().uuidString)
        callbacks[id] = callback
        return id
    }
}

struct CallbackId: Hashable, Codable {
    var callbackId: String
}

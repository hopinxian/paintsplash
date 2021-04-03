//
//  FirebaseOperation.swift
//  paintsplash
//
//  Created by Farrell Nah on 3/4/21.
//

struct FirebaseOperation {
    let path: String
    let data: [String: Any]?
    let onSuccess: (() -> Void)?
    let onError: ((Error?) -> Void)?
}

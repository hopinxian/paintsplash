//
//  FirebaseObserver.swift
//  paintsplash
//
//  Created by Farrell Nah on 3/4/21.
//
import Firebase

struct FirebaseObserver {
    let handle: DatabaseHandle
    let reference: DatabaseReference

    init(handle: DatabaseHandle, reference: DatabaseReference) {
        self.handle = handle
        self.reference = reference
    }
}

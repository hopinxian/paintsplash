//
//  MultiplayerLobby.swift
//  paintsplash
//
//  Created by Farrell Nah on 28/3/21.
//
import Foundation

class MultiplayerLobby {
    var id: UUID
    var isOpen: Bool

    init(id: UUID, isOpen: Bool) {
        self.id = id
        self.isOpen = isOpen
    }
}

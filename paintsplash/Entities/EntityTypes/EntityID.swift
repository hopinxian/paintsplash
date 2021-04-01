//
//  EntityID.swift
//  paintsplash
//
//  Created by Farrell Nah on 1/4/21.
//
import Foundation

struct EntityID: Hashable, Codable {
    var id = UUID()

    init() {
        
    }

    init?(id: String) {
        guard let uuid = UUID(uuidString: id) else {
            return nil
        }

        self.id = uuid
    }
}

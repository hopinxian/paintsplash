//
//  TouchData.swift
//  paintsplash
//
//  Created by Praveen Bala on 6/4/21.
//

protocol TouchData {
    func getTouchId() -> EntityID
    func getTapCount() -> Int
}

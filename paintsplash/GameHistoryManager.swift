//
//  GameHistoryManager.swift
//  paintsplash
//
//  Created by admin on 8/4/21.
//

import Foundation

class GameHistoryManager {
    var history = [Date: SystemData]()

    func addState(_ state: SystemData, at date: Date) {
        history[date] = state
    }
 }

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

    func getStateClosest(to source: Date) -> SystemData {
        var closestDate = Date()
        var closestState: SystemData!
        for (date, data) in history {
            if source.distance(to: date) <= closestDate.distance(to: source) {
                closestDate = date
                closestState = data
            }
        }
        return closestState
    }
 }

//
//  GameHistoryManager.swift
//  paintsplash
//
//  Created by admin on 8/4/21.
//

import Foundation

extension ProcessedInputEvent: Hashable {
    static func == (lhs: ProcessedInputEvent, rhs: ProcessedInputEvent) -> Bool {
        lhs.inputId == rhs.inputId
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(inputId)
    }
}

class GameHistoryManager {
    var history = [InputId: Double]()
    var inputMapping = BidirectionalMap<InputId, ProcessedInputEvent>()

    func addInput(_ input: ProcessedInputEvent) {
        guard let inputId = input.inputId else {
            return
        }
        inputMapping[input] = inputId
        // print("Updated Input: \(type(of: input)) \(inputId.id)")
    }

    func addHistory(_ input: InputId, _ time: Double) {
        guard history[input] == nil else {
            return
        }
        history[input] = time
        // print("Updated history: \(input.id) \(time)")
    }
}

class GameState {
    var data: SystemData

    init(_ data: SystemData) {
        self.data = data
    }
}

class RePrediction {
    static func resolve(_ state: GameState, _ mgr: MultiplayerClient) {
        // have already set the authoritical state

        // now i need to rollback
        let lastProcessedInputId = state.data.lastProcessedInput
        // print("Last processed: \(lastProcessedInputId.id)")
        // print("Process up to: \(InputId.counter - 1)")

        assert(lastProcessedInputId.id <= InputId.counter)

        let historyManager = mgr.gameHistoryManager
        // get all input events that need to be regenerated
        let inputMap = historyManager.inputMapping.forward
        let newInputMapping = inputMap.filter {
            $0.key > lastProcessedInputId
        }
        historyManager.inputMapping.forward = newInputMapping
        var inputsToApply = newInputMapping.map {
            $0.value
        }

        inputsToApply.sort()
        // print("\(inputsToApply.compactMap { $0.inputId?.id })")
        // get sequence of update loop times and the corresponding update events that were last processed then
        historyManager.history = historyManager.history.filter {
            $0.key > lastProcessedInputId
        }
        let times = historyManager.history
        .sorted(by: { $0.key < $1.key })

        var eventIndex = 0
        let eventLength = inputsToApply.count

        // do the actual rollback prediction

        mgr.playerSystem.onMoveEvents = []
        mgr.playerSystem.onShootEvents = []
        mgr.playerSystem.onWeaponChangeEvents = []
        for (lastInputId, deltaTime) in times {
            // send out the past input events in that particular update loop
            while eventIndex < eventLength {
                let event = inputsToApply[eventIndex]
                if let inputId = event.inputId,
                    inputId <= lastInputId {
                    EventSystem.processedInputEvents.post(event: event)
                    eventIndex += 1
                } else {
                    break
                }
            }

            // print("Process update loop of time: \(deltaTime)")
            // do update
//          mgr.transformSystem?.updateEntities(deltaTime)
//          mgr.aiSystem?.updateEntities(deltaTime)
//            animationSystem?.updateEntities(deltaTime)
//            collisionSystem?.updateEntities(deltaTime)
            if let system = mgr.movementSystem as? FrameMovementSystem {
                system.updateEntity(mgr.player, mgr.player, deltaTime)
            } else {
                fatalError("sth")
            }
            mgr.playerSystem?.updateEntities(deltaTime)
        }
        mgr.renderSystem?.updateEntity(mgr.player.id, mgr.player)
        // print("One resolution is done")
    }
}

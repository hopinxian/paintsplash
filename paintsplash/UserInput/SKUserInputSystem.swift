//
//  SKUserInputSystem.swift
//  paintsplash
//
//  Created by Praveen Bala on 6/4/21.
//

class SKUserInputSystem: UserInputSystem {
    private var userInputs = [EntityID: UserInput]()
    private var touchEvents = [TouchEvent]()

    func addEntity(_ entity: GameEntity) {
        guard let userInput = entity as? UserInput else {
            return
        }

        userInputs[entity.id] = userInput
    }

    func removeEntity(_ entity: GameEntity) {
        userInputs[entity.id] = nil
    }

    func updateEntities(_ deltaTime: Double) {
        for input in userInputs.values {
            touchEvents.forEach { sendEvent($0, to: input) }
        }

        touchEvents = []
    }

    private func getSpaceConvertedCoordinates(of vector: Vector2D) -> Vector2D {
        let convertedPos = SpaceConverter.screenToModel(vector)
        return convertedPos
    }

    private func sendEvent(_ event: TouchEvent, to entity: UserInput) {
        switch event {
        case let event as TouchDownEvent:
            entity.touchDown(event: event)
        case let event as TouchMoveEvent:
            entity.touchMove(event: event)
        case let event as TouchUpEvent:
            entity.touchUp(event: event)
        default:
            fatalError("Touch Event type not implemented")
        }
    }

    private func createEvent(type: TouchEvent.Type, touchData: TouchData, at location: Vector2D) -> TouchEvent {
        let id = touchData.getTouchId()
        let touchLocation = getSpaceConvertedCoordinates(of: location)

        switch type {
        case is TouchDownEvent.Type:
            return TouchDownEvent(location: touchLocation, touchId: id)
        case is TouchMoveEvent.Type:
            return TouchMoveEvent(location: touchLocation, touchId: id)
        case is TouchUpEvent.Type:
            return TouchUpEvent(location: touchLocation, touchId: id)
        default:
            fatalError("Touch Event type not implemented")
        }

    }

    func touchDown(touchData: TouchData, at location: Vector2D) {
        let event = createEvent(type: TouchDownEvent.self, touchData: touchData, at: location)
        touchEvents.append(event)
    }

    func touchMoved(touchData: TouchData, at location: Vector2D) {
        let event = createEvent(type: TouchMoveEvent.self, touchData: touchData, at: location)
        touchEvents.append(event)
    }

    func touchUp(touchData: TouchData, at location: Vector2D) {
        let event = createEvent(type: TouchUpEvent.self, touchData: touchData, at: location)
        touchEvents.append(event)
    }
}

//
//  SKUserInputSystem.swift
//  paintsplash
//
//  Created by Praveen Bala on 6/4/21.
//

import SpriteKit

class SKUserInputSystem: UserInputSystem {
    let renderSystem: SKRenderSystem
    var userInputs = [EntityID: UserInput]()
    var touchDownEvents = [TouchDownEvent]()
    var touchUpEvents = [TouchUpEvent]()
    var touchMoveEvents = [TouchMoveEvent]()

    init(renderSystem: SKRenderSystem) {
        self.renderSystem = renderSystem
    }

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
        for (_, input) in userInputs {
            for event in touchDownEvents {
                input.touchDown(event: event)
            }

            for event in touchUpEvents {
                input.touchUp(event: event)
            }

            for event in touchMoveEvents {
                input.touchMove(event: event)
            }
        }

        touchDownEvents = []
        touchUpEvents = []
        touchMoveEvents = []
    }

    private func getSpaceConvertedCoordinates(of vector: Vector2D) -> Vector2D {
        let convertedPos = SpaceConverter.screenToModel(vector)
        return convertedPos
    }

     func onTouchDown(of touchable: Touchable, at location: Vector2D) {
        let id = touchable.getTouchId()
        let touchLocation = getSpaceConvertedCoordinates(of: location)
        let event = TouchDownEvent(location: touchLocation, associatedId: id)
        touchDownEvents.append(event)
    }

     func onTouchMoved(of touchable: Touchable, at location: Vector2D) {
        let id = touchable.getTouchId()
        let touchLocation = getSpaceConvertedCoordinates(of: location)
        let event = TouchMoveEvent(location: touchLocation, associatedId: id)
        touchMoveEvents.append(event)
    }

    func onTouchUp(of touchable: Touchable, at location: Vector2D) {
        let id = touchable.getTouchId()
        let touchLocation = getSpaceConvertedCoordinates(of: location)
        let event = TouchUpEvent(location: touchLocation, associatedId: id)
        touchUpEvents.append(event)
    }
}

class TouchEvent {
    var location: Vector2D
    var associatedId: EntityID

    init(location: Vector2D, associatedId: EntityID) {
        self.location = location
        self.associatedId = associatedId
    }
}

class TouchDownEvent: TouchEvent {

}

class TouchUpEvent: TouchEvent {

}

class TouchMoveEvent: TouchEvent {

}

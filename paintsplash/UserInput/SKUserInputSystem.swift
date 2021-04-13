//
//  SKUserInputSystem.swift
//  paintsplash
//
//  Created by Praveen Bala on 6/4/21.
//

import SpriteKit

class SKUserInputSystem: UserInputSystem {
    let renderSystem: SKRenderSystem
    var touchableEntities = Set<EntityID>()

    init(renderSystem: SKRenderSystem) {
        self.renderSystem = renderSystem
        initListeners()
    }

    func addTouchable(_ entity: GameEntity) {
        touchableEntities.insert(entity.id)
    }

    func updateTouchable(_ entity: GameEntity) {
        // do nothing
    }

    func removeTouchable(_ entity: GameEntity) {
        touchableEntities.remove(entity.id)
    }

    private func initListeners() {
        EventSystem.rawTouchInputEvent.rawTouchDownEvent.subscribe { [weak self] event in
            self?.onTouchDown(of: event.touchable, at: event.location)
        }

        EventSystem.rawTouchInputEvent.rawTouchMovedEvent.subscribe { [weak self] event in
            self?.onTouchMoved(of: event.touchable, at: event.location)
        }

        EventSystem.rawTouchInputEvent.rawTouchUpEvent.subscribe { [weak self] event in
            self?.onTouchUp(of: event.touchable, at: event.location)
        }
    }

    private func getSpaceConvertedCoordinates(of vector: Vector2D) -> Vector2D {
        let convertedPos = SpaceConverter.screenToModel(vector)
        return convertedPos
    }

    private func onTouchDown(of touchable: Touchable, at location: Vector2D) {
        let id = touchable.getTouchId()
        let touchLocation = getSpaceConvertedCoordinates(of: location)
        let event = TouchDownEvent(location: touchLocation, associatedId: id)
        EventSystem.inputEvents.touchDownEvent.post(event: event)
    }

    private func onTouchMoved(of touchable: Touchable, at location: Vector2D) {
        let id = touchable.getTouchId()
        let touchLocation = getSpaceConvertedCoordinates(of: location)
        let event = TouchMovedEvent(location: touchLocation, associatedId: id)
        EventSystem.inputEvents.touchMovedEvent.post(event: event)
    }

    private func onTouchUp(of touchable: Touchable, at location: Vector2D) {
        let id = touchable.getTouchId()
        let touchLocation = getSpaceConvertedCoordinates(of: location)
        let event = TouchUpEvent(location: touchLocation, associatedId: id)
        EventSystem.inputEvents.touchUpEvent.post(event: event)
    }
}

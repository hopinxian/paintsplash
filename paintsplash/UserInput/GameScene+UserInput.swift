//
//  GameScene+UserInput.swift
//  paintsplash
//
//  Created by Farrell Nah on 15/3/21.
//
//  swiftlint:disable override_in_extension

import SpriteKit

extension GameScene: UserInput {
    func touchDown(atPoint pos: CGPoint, touchable: Touchable) {
        let event = RawTouchDownEvent(location: Vector2D(pos), touchable: touchable)
        EventSystem.rawTouchInputEvent.rawTouchDownEvent.post(event: event)
    }

    func touchMoved(toPoint pos: CGPoint, touchable: Touchable) {
        let event = RawTouchMovedEvent(location: Vector2D(pos), touchable: touchable)
        EventSystem.rawTouchInputEvent.rawTouchMovedEvent.post(event: event)
    }

    func touchUp(atPoint pos: CGPoint, touchable: Touchable) {
        let event = RawTouchUpEvent(location: Vector2D(pos), touchable: touchable)
        EventSystem.rawTouchInputEvent.rawTouchUpEvent.post(event: event)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        touches.forEach { self.touchDown(atPoint: $0.location(in: self), touchable: $0) }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        touches.forEach { self.touchMoved(toPoint: $0.location(in: self), touchable: $0) }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        touches.forEach { self.touchUp(atPoint: $0.location(in: self), touchable: $0) }
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touches.forEach { self.touchUp(atPoint: $0.location(in: self), touchable: $0) }
    }
}

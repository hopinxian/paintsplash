//
//  GameScene+UserInput.swift
//  paintsplash
//
//  Created by Farrell Nah on 15/3/21.
//
//  swiftlint:disable override_in_extension

import SpriteKit

extension GameScene: UserInput {
    func touchDown(atPoint pos: CGPoint) {
        let convertedPos = SpaceConverter.screenToModel(pos)
        for node in nodes(at: pos) {
            let event = RawTouchDownEvent(location: convertedPos, touchable: node)
            EventSystem.rawTouchInputEvent.rawTouchDownEvent.post(event: event)
        }

    }

    func touchMoved(toPoint pos: CGPoint) {
        let convertedPos = SpaceConverter.screenToModel(pos)
        for node in nodes(at: pos) {
            let event = RawTouchMovedEvent(location: convertedPos, touchable: node)
            EventSystem.rawTouchInputEvent.rawTouchMovedEvent.post(event: event)
        }
    }

    func touchUp(atPoint pos: CGPoint) {
        let convertedPos = SpaceConverter.screenToModel(pos)
        for node in nodes(at: pos) {
            let event = RawTouchUpEvent(location: convertedPos, touchable: node)
            EventSystem.rawTouchInputEvent.rawTouchUpEvent.post(event: event)
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches { self.touchDown(atPoint: touch.location(in: self)) }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches { self.touchMoved(toPoint: touch.location(in: self)) }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches { self.touchUp(atPoint: touch.location(in: self)) }
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches { self.touchUp(atPoint: touch.location(in: self)) }
    }
}

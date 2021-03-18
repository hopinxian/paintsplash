//
//  GameScene+UserInput.swift
//  paintsplash
//
//  Created by Farrell Nah on 15/3/21.
//
import SpriteKit

extension GameScene: UserInput {
    func touchDown(atPoint pos : CGPoint) {
        let convertedPos = spaceConverter.screenToModel(pos)
        let event = TouchDownEvent(location: convertedPos)
        EventSystem.inputEvents.touchDownEvent.post(event: event)
    }

    func touchMoved(toPoint pos : CGPoint) {
        let convertedPos = spaceConverter.screenToModel(pos)
        let event = TouchMovedEvent(location: convertedPos)
        EventSystem.inputEvents.touchMovedEvent.post(event: event)
    }

    func touchUp(atPoint pos : CGPoint) {
        let convertedPos = spaceConverter.screenToModel(pos)
        let event = TouchUpEvent(location: convertedPos)
        EventSystem.inputEvents.touchUpEvent.post(event: event)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }

    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }

}

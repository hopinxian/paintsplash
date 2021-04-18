//
//  GameScene+UserInput.swift
//  paintsplash
//
//  Created by Farrell Nah on 15/3/21.
//
//  swiftlint:disable override_in_extension

import SpriteKit

extension GameScene {
    func touchDown(atPoint pos: CGPoint, touchData: TouchData) {
        inputSystem?.touchDown(touchData: touchData, at: Vector2D(pos))
    }

    func touchMoved(toPoint pos: CGPoint, touchData: TouchData) {
        inputSystem?.touchMoved(touchData: touchData, at: Vector2D(pos))
    }

    func touchUp(atPoint pos: CGPoint, touchData: TouchData) {
        inputSystem?.touchUp(touchData: touchData, at: Vector2D(pos))
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        touches.forEach { touch in
            let location = touch.location(in: self)
            self.touchDown(atPoint: location, touchData: touch)
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        touches.forEach { touch in
            let location = touch.location(in: self)
            self.touchMoved(toPoint: location, touchData: touch)
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        touches.forEach { touch in
            let location = touch.location(in: self)
            self.touchUp(atPoint: location, touchData: touch)
        }
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touches.forEach { touch in
            let location = touch.location(in: self)
            self.touchUp(atPoint: location, touchData: touch)
        }
    }
}

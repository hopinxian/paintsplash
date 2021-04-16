//
//  GameScene+UserInput.swift
//  paintsplash
//
//  Created by Farrell Nah on 15/3/21.
//
//  swiftlint:disable override_in_extension

import SpriteKit

extension GameScene {
    func touchDown(atPoint pos: CGPoint, touchable: Touchable) {
        inputSystem?.onTouchDown(of: touchable, at: Vector2D(pos))
    }

    func touchMoved(toPoint pos: CGPoint, touchable: Touchable) {
        inputSystem?.onTouchMoved(of: touchable, at: Vector2D(pos))
    }

    func touchUp(atPoint pos: CGPoint, touchable: Touchable) {
        inputSystem?.onTouchUp(of: touchable, at: Vector2D(pos))
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

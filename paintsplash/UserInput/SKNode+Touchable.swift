//
//  SKNode+Touchable.swift
//  paintsplash
//
//  Created by Praveen Bala on 6/4/21.
//

import SpriteKit
//swiftlint:disable force_cast

extension SKNode: Touchable { }

//    func touchDown(at point: Vector2D) {
//        let event = RawTouchDownEvent(location: point, touchable: self as! SKNode)
//        print(self as! SKNode)
//        EventSystem.rawTouchInputEvent.rawTouchDownEvent.post(event: event)
//    }
//
//    func touchMoved(to point: Vector2D) {
//        let event = RawTouchMovedEvent(location: point, touchable: self as! SKNode)
//        print(self)
//        EventSystem.rawTouchInputEvent.rawTouchMovedEvent.post(event: event)
//    }
//
//    func touchUp(at point: Vector2D) {
//        let event = RawTouchUpEvent(location: point, touchable: self as! SKNode)
//
//        EventSystem.rawTouchInputEvent.rawTouchUpEvent.post(event: event)
//    }
//
//    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for touch in touches {
//            let convertedPos = SpaceConverter.screenToModel(touch.location(in: self))
//            self.touchDown(at: convertedPos)
//        }
//    }
//
//    open override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for touch in touches {
//            let convertedPos = SpaceConverter.screenToModel(touch.location(in: self))
//            self.touchMoved(to: convertedPos)
//        }
//    }
//
//    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for touch in touches {
//            let convertedPos = SpaceConverter.screenToModel(touch.location(in: self))
//            self.touchUp(at: convertedPos)
//        }
//    }
//
//    open override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for touch in touches {
//            let convertedPos = SpaceConverter.screenToModel(touch.location(in: self))
//            self.touchUp(at: convertedPos)
//        }
//    }
//}


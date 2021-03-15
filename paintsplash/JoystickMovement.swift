//
//  JoystickMovement.swift
//  paintsplash
//
//  Created by Praveen Bala on 15/3/21.
//

import SpriteKit

class JoystickMovement: SKNode {

    private var handleNode: SKShapeNode
    private var backgroundNode: SKShapeNode

    private let backgroundDiameter: Double = 100
    private let handleDiameter: Double = 50

    private var tracking = false
    private var handlers = [MovementState : (Vector2D) -> Void]()

    private var backgroundRadius: Double {
        backgroundDiameter / 2
    }

    private var handleRadius: Double {
        handleDiameter / 2
    }

    enum MovementState {
        case begin
        case moving
        case end
    }

    override init() {
        backgroundNode = SKShapeNode(circleOfRadius: CGFloat(50))
        handleNode = SKShapeNode(circleOfRadius: CGFloat(25))

        super.init()

        backgroundNode.fillColor = UIColor.gray.withAlphaComponent(0.25)
        handleNode.fillColor = UIColor.gray.withAlphaComponent(0.5)

        self.addChild(backgroundNode)
        self.addChild(handleNode)

        handleNode.zPosition = backgroundNode.zPosition + 1

        self.isUserInteractionEnabled = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let _ = touch.location(in: self) // relative position of touch
//            if !tracking {
//                tracking = true
//            }
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = Vector2D(touch.location(in: self)) // relative position of touch
//            guard tracking else {
//                continue
//            }
            var newLocation = Vector2D.zero
            newLocation += location

            if newLocation.magnitude > backgroundRadius {
                newLocation /= newLocation.magnitude
                newLocation *= backgroundRadius
            }

            handlers[.moving]?(newLocation)
            handleNode.position = CGPoint(newLocation)
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        tracking = false
        for touch in touches {
            let location = Vector2D(touch.location(in: self))
            handlers[.end]?(location)
        }
        
        handleNode.position = backgroundNode.position
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
//        tracking = false
        handleNode.position = backgroundNode.position
    }

    func setHandler(for state: MovementState, _ handler: @escaping (Vector2D) -> Void) {
        handlers[state] = handler
    }
}

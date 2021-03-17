//
//  JoystickMovement.swift
//  paintsplash
//
//  Created by Praveen Bala on 15/3/21.
//

import SpriteKit

class Joystick: GameEntity, Renderable {
    var zPosition: Int

    var renderColor: PaintColor?

    var spriteName: String

    var currentAnimation: Animation?

    var transform: Transform

    private let foregroundNode: JoystickForeground

    private let backgroundDiameter: Double = 100
    private let handleDiameter: Double = 50

    private var tracking = false

    private var backgroundRadius: Double {
        backgroundDiameter / 2
    }

    private var handleRadius: Double {
        handleDiameter / 2
    }

    init(position: Vector2D) {
        renderColor = nil
        spriteName = "joystick-background"
        currentAnimation = nil
        transform = Transform.standard
        transform.position = position
        zPosition = 0
        foregroundNode = JoystickForeground(position: position, zPosition: zPosition + 100)

        super.init()

        EventSystem.inputEvents.subscribe(listener: onTouch)
    }

    override func spawn(gameManager: GameManager) {
        gameManager.getRenderSystem().addRenderable(self)
        foregroundNode.spawn(gameManager: gameManager)
        super.spawn(gameManager: gameManager)
    }

    override func update(gameManager: GameManager) {
        gameManager.getRenderSystem().updateRenderable(self)
        foregroundNode.update(gameManager: gameManager)
        super.update(gameManager: gameManager)
    }

    func onTouch(inputEvent: TouchInputEvent) {
        switch inputEvent {
        case let touchDownEvent as TouchDownEvent:
            onTouchDown(location: touchDownEvent.location)
        case let touchUpEvent as TouchUpEvent:
            onTouchUp(location: touchUpEvent.location)
        case let touchMovedEvent as TouchMovedEvent:
            onTouchMoved(location: touchMovedEvent.location)
        default:
            break
        }
    }

    func onTouchDown(location: Vector2D) {
        if Vector2D.magnitude(of: location - transform.position) < backgroundRadius {
            tracking = true
        }
    }

    func onTouchMoved(location: Vector2D) {
        guard tracking else {
            return
        }

        var newLocation = location
        let displacement = newLocation - transform.position

        if displacement.magnitude > backgroundRadius {
            let newDisplacement = Vector2D.normalize(displacement) * backgroundRadius
            newLocation = transform.position + newDisplacement
        }

        foregroundNode.move(to: newLocation)

        let event = PlayerMoveEvent(direction: displacement.unitVector)
        EventSystem.processedInputEvents.playerMoveEvent.post(event: event)
    }

    func onTouchUp(location: Vector2D) {
        tracking = false
        foregroundNode.move(to: transform.position)
        let event = PlayerMoveEvent(direction: Vector2D.zero)
        EventSystem.processedInputEvents.playerMoveEvent.post(event: event)
    }
}

class JoystickForeground: GameEntity, Renderable {
    var zPosition: Int

    var renderColor: PaintColor?

    var spriteName: String

    var currentAnimation: Animation?

    var transform: Transform

    init(position: Vector2D, zPosition: Int) {
        self.zPosition = zPosition
        renderColor = nil
        spriteName = "joystick-foreground"
        currentAnimation = nil
        transform = Transform(position: position, rotation: 0.0, size: Vector2D(42, 42))
        super.init()
    }

    override func spawn(gameManager: GameManager) {
        gameManager.getRenderSystem().addRenderable(self)
        super.spawn(gameManager: gameManager)
    }

    override func update(gameManager: GameManager) {
        gameManager.getRenderSystem().updateRenderable(self)
        super.update(gameManager: gameManager)
    }

}

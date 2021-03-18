//
//  JoystickMovement.swift
//  paintsplash
//
//  Created by Praveen Bala on 15/3/21.
//

class Joystick: GameEntity, Renderable {
    var zPosition: Int

    var spriteName: String

    var defaultAnimation: Animation?

    var transform: Transform

    private let foregroundNode: JoystickForeground

    private let backgroundDiameter: Double = 200
    private let handleDiameter: Double = 150

    private var tracking = false

    private var backgroundRadius: Double {
        backgroundDiameter / 2
    }

    private var handleRadius: Double {
        handleDiameter / 2
    }

    init(position: Vector2D) {
        spriteName = "joystick-background"
        defaultAnimation = nil
        transform = Transform.standard
        transform.position = position
        zPosition = 0
        foregroundNode = JoystickForeground(position: position, zPosition: zPosition + 1)

        super.init()

        EventSystem.inputEvents.touchDownEvent.subscribe(listener: onTouchDown)
        EventSystem.inputEvents.touchMovedEvent.subscribe(listener: onTouchMoved)
        EventSystem.inputEvents.touchUpEvent.subscribe(listener: onTouchUp)
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

    func onTouchDown(event: TouchDownEvent) {
        print("touchdown")
        if Vector2D.magnitude(of: event.location - transform.position) < backgroundRadius {
            tracking = true
        }
    }

    func onTouchMoved(event: TouchMovedEvent) {
        guard tracking else {
            return
        }

        var newLocation = event.location
        let displacement = newLocation - transform.position

        if displacement.magnitude > backgroundRadius {
            let newDisplacement = Vector2D.normalize(displacement) * backgroundRadius
            newLocation = transform.position + newDisplacement
        }

        foregroundNode.move(to: newLocation)

        let event = PlayerMoveEvent(direction: displacement.unitVector)
        EventSystem.processedInputEvents.playerMoveEvent.post(event: event)
    }

    func onTouchUp(event: TouchUpEvent) {
        tracking = false
        foregroundNode.move(to: transform.position)
        let event = PlayerMoveEvent(direction: Vector2D.zero)
        EventSystem.processedInputEvents.playerMoveEvent.post(event: event)
    }
}

class JoystickForeground: GameEntity, Renderable {
    var zPosition: Int

    var spriteName: String

    var defaultAnimation: Animation?

    var transform: Transform

    init(position: Vector2D, zPosition: Int) {
        self.zPosition = zPosition
        spriteName = "joystick-foreground"
        defaultAnimation = nil
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

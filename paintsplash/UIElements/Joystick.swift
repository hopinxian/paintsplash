//
//  JoystickMovement.swift
//  paintsplash
//
//  Created by Praveen Bala on 15/3/21.
//

class Joystick: GameEntity, Renderable {
    var renderComponent: RenderComponent
    var transformComponent: TransformComponent

    private let foregroundNode: JoystickForeground

    private var tracking = false

    private var backgroundRadius: Double {
        transformComponent.size.x / 2
    }

    private var handleRadius: Double {
        transformComponent.size.x / 2
    }

    override init() {
        let renderType = RenderType.sprite(spriteName: Constants.JOYSTICK_SPRITE)

        self.transformComponent = TransformComponent(
            position: Constants.JOYSTICK_POSITION,
            rotation: 0,
            size: Constants.JOYSTICK_SIZE
        )

        self.renderComponent = RenderComponent(
            renderType: renderType,
            zPosition: Constants.ZPOSITION_UI_ELEMENT
        )

        foregroundNode = JoystickForeground(
            position: Constants.JOYSTICK_POSITION,
            size: Constants.JOYSTICK_SIZE * 0.60,
            zPosition: renderComponent.zPosition + 1
        )

        super.init()

        EventSystem.inputEvents.touchDownEvent.subscribe(listener: onTouchDown)
        EventSystem.inputEvents.touchMovedEvent.subscribe(listener: onTouchMoved)
        EventSystem.inputEvents.touchUpEvent.subscribe(listener: onTouchUp)
    }

    override func spawn() {
        super.spawn()
        foregroundNode.spawn()
    }

    override func destroy() {
        super.destroy()
        foregroundNode.destroy()
    }

    func onTouchDown(event: TouchDownEvent) {
        if Vector2D.magnitude(of: event.location - transformComponent.localPosition) < backgroundRadius {
            tracking = true
        }
    }

    func onTouchMoved(event: TouchMovedEvent) {
        guard tracking else {
            return
        }

        var newLocation = event.location
        let displacement = newLocation - transformComponent.localPosition

        if displacement.magnitude > backgroundRadius {
            let newDisplacement = Vector2D.normalize(displacement) * backgroundRadius
            newLocation = transformComponent.localPosition + newDisplacement
        }

        foregroundNode.transformComponent.localPosition = newLocation

        let event = PlayerMoveEvent(direction: displacement.unitVector)
        EventSystem.processedInputEvents.playerMoveEvent.post(event: event)
    }

    func onTouchUp(event: TouchUpEvent) {
        tracking = false
        foregroundNode.transformComponent.localPosition = transformComponent.localPosition
        let event = PlayerMoveEvent(direction: Vector2D.zero)
        EventSystem.processedInputEvents.playerMoveEvent.post(event: event)
    }
}

class JoystickForeground: GameEntity, Renderable {
    var renderComponent: RenderComponent
    var transformComponent: TransformComponent

    init(position: Vector2D, size: Vector2D, zPosition: Int) {
        let renderType = RenderType.sprite(spriteName: "joystick-foreground")

        self.renderComponent = RenderComponent(renderType: renderType, zPosition: zPosition)
        self.transformComponent = TransformComponent(position: position, rotation: 0, size: size)

        super.init()
    }
}

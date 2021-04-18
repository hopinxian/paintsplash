//
//  JoystickMovement.swift
//  paintsplash
//
//  Created by Praveen Bala on 15/3/21.
//

class Joystick: UIEntity, Renderable, UserInput {
    var renderComponent: RenderComponent
    var transformComponent: TransformComponent
    let associatedEntity: EntityID

    private (set) var displacement: Vector2D = .zero

    private let foregroundNode: JoystickForeground

    private (set) var trackedId: EntityID?

    private var backgroundRadius: Double {
        transformComponent.size.x / 2
    }

    private var handleRadius: Double {
        transformComponent.size.x / 2
    }

    init(associatedEntityID: EntityID, position: Vector2D) {
        let renderType = RenderType.sprite(spriteName: Constants.JOYSTICK_SPRITE)

        self.associatedEntity = associatedEntityID

        self.transformComponent = TransformComponent(
            position: position,
            rotation: 0,
            size: Constants.JOYSTICK_SIZE
        )

        self.renderComponent = RenderComponent(
            renderType: renderType,
            zPosition: Constants.ZPOSITION_JOYSTICK,
            zPositionGroup: .ui
        )

        foregroundNode = JoystickForeground(
            position: position,
            size: Constants.JOYSTICK_FOREGROUND_SIZE,
            zPosition: renderComponent.zPosition + 1
        )

        super.init()
    }

    override func spawn() {
        super.spawn()
        foregroundNode.spawn()
    }

    override func destroy() {
        super.destroy()
        foregroundNode.destroy()
    }

    func touchDown(event: TouchDownEvent) {
        guard trackedId == nil else {
            return
        }

        if Vector2D.magnitude(of: event.location - transformComponent.localPosition) < backgroundRadius {
            trackedId = event.touchId
        }
    }

    func touchMove(event: TouchMoveEvent) {
        guard event.touchId == trackedId else {
            return
        }

        var newLocation = event.location
        let displacement = newLocation - transformComponent.localPosition

        if displacement.magnitude > backgroundRadius {
            let newDisplacement =
                Vector2D.normalize(displacement) * backgroundRadius
            newLocation = transformComponent.localPosition + newDisplacement
        }

        foregroundNode.transformComponent.localPosition = newLocation
        self.displacement = displacement.unitVector
    }

    func touchUp(event: TouchUpEvent) {
        guard event.touchId == trackedId else {
            return
        }

        trackedId = nil
        foregroundNode.transformComponent.localPosition = transformComponent.localPosition
        self.displacement = .zero
    }

    class JoystickForeground: UIEntity, Renderable {
        var renderComponent: RenderComponent
        var transformComponent: TransformComponent

        init(position: Vector2D, size: Vector2D, zPosition: Int) {
            let renderType = RenderType.sprite(spriteName: Constants.JOYSTICK_FOREGROUND_SPRITE)

            self.renderComponent = RenderComponent(
                renderType: renderType,
                zPosition: zPosition,
                zPositionGroup: .ui
            )

            self.transformComponent = TransformComponent(
                position: position,
                rotation: 0,
                size: size
            )

            super.init()
        }
    }
}

//
//  GunAimGuide.swift
//  paintsplash
//
//  Created by Farrell Nah on 10/4/21.
//

class GunAimGuide: UIEntity, Renderable, AimGuide, Colorable {
    var renderComponent: RenderComponent
    var transformComponent: TransformComponent
    var owner: Transformable
    var color: PaintColor
    var direction: Vector2D

    init(owner: Transformable, color: PaintColor, direction: Vector2D = Vector2D.right) {
        self.owner = owner
        self.renderComponent = RenderComponent(
            renderType: .sprite(spriteName: "StraightArrow"),
            zPosition: Constants.ZPOSITION_PLAYER - 1,
            cropInParent: false
        )

        let transformComponent = TransformComponent(position: Vector2D.zero, rotation: 0, size: Vector2D(100, 50))
        transformComponent.addParent(owner)

        self.transformComponent = transformComponent

        self.color = color

        self.direction = direction

        super.init()

        self.aim(at: direction)
    }

    func aim(at direction: Vector2D) {
        transformComponent.rotation = Vector2D.angleOf(direction)
        transformComponent.localPosition = Vector2D.normalize(direction) * transformComponent.size.x / 2
        self.direction = direction
    }
}

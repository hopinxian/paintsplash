//
//  PaintAmmoDisplay.swift
//  paintsplash
//
//  Created by Farrell Nah on 16/3/21.
//

class PaintAmmoDisplay: UIEntity, Renderable, Colorable {
    let renderComponent: RenderComponent
    let transformComponent: TransformComponent

    var color: PaintColor

    init(paintAmmo: PaintAmmo, position: Vector2D, zPosition: Int) {
        self.color = paintAmmo.color

        let renderType = RenderType.sprite(spriteName: "WhiteSquare")
        self.transformComponent = TransformComponent(
            position: position,
            rotation: 0,
            size: Constants.PAINT_AMMO_DISPLAY_SIZE
        )

        self.renderComponent = RenderComponent(renderType: renderType, zPosition: zPosition)

        super.init()
    }
}

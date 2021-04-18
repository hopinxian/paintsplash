//
//  UIBar.swift
//  paintsplash
//
//  Created by Praveen Bala on 20/3/21.
//

class UIBar: UIEntity, Renderable {
    var renderComponent: RenderComponent
    var transformComponent: TransformComponent

    init(position: Vector2D, size: Vector2D, spritename: String) {
        let renderType = RenderType.sprite(spriteName: spritename)

        self.renderComponent = RenderComponent(
            renderType: renderType,
            zPosition: Constants.ZPOSITION_WALLS,
            zPositionGroup: .background
        )

        self.transformComponent = TransformComponent(
            position: position, rotation: 0.0, size: size
        )

        super.init()
    }
}

class BottomUIBar: UIBar {
    override init(position: Vector2D = Constants.BOTTOM_BAR_POSITION,
                  size: Vector2D = Constants.BOTTOM_BAR_SIZE,
                  spritename: String = Constants.BOTTOM_BAR_SPRITE) {
        super.init(position: position, size: size, spritename: spritename)
    }
}

class TopUIBar: UIBar {
    override init(position: Vector2D = Constants.TOP_BAR_POSITION,
                  size: Vector2D = Constants.TOP_BAR_SIZE,
                  spritename: String = Constants.TOP_BAR_SPRITE) {
        super.init(position: position, size: size, spritename: spritename)
    }
}

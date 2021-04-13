//
//  SceneNode.swift
//  paintsplash
//
//  Created by Praveen Bala on 13/4/21.
//

class SceneNode: GameEntity, Renderable {
    var renderComponent: RenderComponent
    var transformComponent: TransformComponent

    init(sceneName: String, size: Vector2D, position: Vector2D) {
        let renderType = RenderType.scene(name: sceneName)
        self.renderComponent = RenderComponent(
            renderType: renderType,
            zPosition: Constants.ZPOSITION_SCORE
        )
        self.transformComponent = TransformComponent(
            position: position,
            rotation: 0.0,
            size: size
        )

        super.init()
    }
}


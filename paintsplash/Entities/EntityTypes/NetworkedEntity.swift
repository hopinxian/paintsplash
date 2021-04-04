//
//  NetworkedEntity.swift
//  paintsplash
//
//  Created by Farrell Nah on 3/4/21.
//

class NetworkedEntity: GameEntity, Renderable, Animatable, Colorable {
    var renderComponent: RenderComponent
    var transformComponent: TransformComponent
    var animationComponent: AnimationComponent
    var color: PaintColor

    init(id: EntityID,
         renderComponent: RenderComponent?,
         transformComponent: TransformComponent?,
         animationComponent: AnimationComponent?,
         color: PaintColor?) {
        self.renderComponent = renderComponent ??
            RenderComponent(renderType: .sprite(spriteName: ""), zPosition: 0)

        self.animationComponent = animationComponent ??
            AnimationComponent()

        self.transformComponent = transformComponent ??
            TransformComponent(position: .zero, rotation: 0, size: .zero)

        self.color = color ?? .white

        super.init()

        self.id = id
    }
}

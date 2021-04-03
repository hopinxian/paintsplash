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
         renderComponent: RenderComponent,
         transformComponent: TransformComponent,
         animationComponent: AnimationComponent,
         color: PaintColor) {
        self.renderComponent = renderComponent
        self.animationComponent = animationComponent
        self.transformComponent = transformComponent
        self.color = color

        super.init()

        self.id = id
    }
}

//
//  HeartDisplay.swift
//  paintsplash
//
//  Created by Farrell Nah on 19/3/21.
//

class HeartDisplay: GameEntity {
    init(position: Vector2D, zPosition: Int) {
        addComponent(TransformComponent(position: position, rotation: 0.0, size: Vector2D(50, 50)))
        addComponent(RenderComponent(spriteName: "heart", defaultAnimation: nil, zPosition: Constants.ZPOSITION_UI_ELEMENT))
        super.init()
    }
}

//
//  VerticalStackDisplay.swift
//  paintsplash
//
//  Created by Farrell Nah on 16/3/21.
//

class VerticalStackDisplay: GameEntity, Renderable {
    var renderColor: PaintColor?

    var spriteName: String

    var currentAnimation: Animation?

    var transform: Transform

    var stackItems: [Renderable]

    init(position: Vector2D, size: Vector2D, backgroundSprite: String) {
        self.spriteName = backgroundSprite
        self.transform = Transform(position: position, rotation: 0.0, size: size)
        self.currentAnimation = nil
        self.stackItems = []
        super.init()
    }

    func insert(at index: Int) {

    }

    func remove(at index: Int) {

    }

    func insertTop() {

    }

    func insertBottom() {

    }

    func removeTop() {

    }

    func removeBottom() {

    }

    func changeItems(to newItems: [Renderable]) {

    }

    private func rerender() {
        for item in stackItems {
            
        }
    }
}

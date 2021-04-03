//
//  HorizontalStackDisplay.swift
//  paintsplash
//
//  Created by Farrell Nah on 19/3/21.
//

class HorizontalStack<ItemType: Renderable>: GameEntity, Renderable, Animatable {

    var items: [ItemType]

    let seperation: Double
    let leftPadding: Double
    let topPadding: Double
    let bottomPadding: Double
    var zPosition: Int

    private var startPosition: Vector2D

    var transformComponent: TransformComponent
    var renderComponent: RenderComponent
    var animationComponent: AnimationComponent

    init(
        position: Vector2D,
        size: Vector2D,
        backgroundSprite: String,
        rotation: Double = 0.0,
        seperation: Double = 20.0,
        leftPadding: Double = 25.0,
        topPadding: Double = 10.0,
        bottomPadding: Double = 10.0
    ) {
        self.items = []
        self.seperation = seperation
        self.leftPadding = leftPadding
        self.topPadding = topPadding
        self.bottomPadding = bottomPadding
        self.zPosition = Constants.ZPOSITION_UI_ELEMENT

        self.transformComponent = TransformComponent(
            position: position,
            rotation: rotation,
            size: size
        )

        self.renderComponent = RenderComponent(
            renderType: .sprite(spriteName: backgroundSprite),
            zPosition: zPosition
        )

        self.animationComponent = AnimationComponent()

        let startX = leftPadding - (transformComponent.size.x / 2)
        let startY = bottomPadding - topPadding

        self.startPosition = transformComponent.localPosition + Vector2D(startX, startY)

        super.init()
    }

    func insert(item: ItemType, at index: Int) {
        clearViews()
        items.insert(item, at: index)
        renderViews()
    }

    func remove(at index: Int) {
        let item = items[index]
        let width = item.transformComponent.size.x

        shiftItemsLeft(from: index + 1, to: items.count - 1, xDistance: width)

        items.remove(at: index)
        item.destroy()
    }

    func insertTop(item: ItemType) {
        var nextPosition = startPosition

        // if first item exists, change next position
        if let firstItem = items.last {
            let x = firstItem.transformComponent.localPosition.x + seperation + item.transformComponent.size.x
            nextPosition = Vector2D(x, startPosition.y)
        }

        items.append(item)

        // get position to add stuff
        item.transformComponent.localPosition = nextPosition
        item.renderComponent.zPosition = zPosition + 1
        item.spawn()
    }

    func insertBottom(item: ItemType) {
        clearViews()
        items.insert(item, at: 0)
        renderViews()
    }

    func removeTop() {
        clearViews()
        items.removeLast()
        renderViews()
    }

    func removeBottom() {
        clearViews()
        items.removeFirst()
        renderViews()
    }

    private func shiftItemsLeft(from: Int, to: Int, xDistance: Double) {
        for (index, item) in items.enumerated() where index >= from && index <= to {
            item.transformComponent.localPosition -= Vector2D(xDistance + seperation, 0)
        }
    }

    private func shiftItemsRight(from: Int, to: Int, xDistance: Double) {

    }

    func changeItems(to newItems: [ItemType]) {
        clearViews()
        items = newItems
        renderViews()
    }

    private func clearViews() {
        for item in items {
            item.destroy()
        }
    }

    private func renderViews() {
        guard let firstItem = items.first else {
            return
        }

        let startX = -(transformComponent.size.x / 2) +
            (firstItem.transformComponent.size.x / 2) +
            leftPadding
        let startY = bottomPadding - topPadding
        var nextPosition = transformComponent.localPosition + Vector2D(startX, startY)

        for item in items {
            item.transformComponent.localPosition = nextPosition
            item.renderComponent.zPosition = zPosition + 1
            item.spawn()
            nextPosition += Vector2D(item.transformComponent.size.x + seperation, 0)
        }
    }
}

//
//  VerticalStackDisplay.swift
//  paintsplash
//
//  Created by Farrell Nah on 16/3/21.
//

class VerticalStack<ItemType: Renderable>: UIEntity, Renderable, Animatable {
    var animationComponent: AnimationComponent
    var renderComponent: RenderComponent
    var transformComponent: TransformComponent

    var items: [ItemType]
    var zPosition: Int

    let seperation: Double
    let leftPadding: Double
    let rightPadding: Double
    let bottomPadding: Double

    init(
        position: Vector2D,
        size: Vector2D,
        backgroundSprite: String,
        rotation: Double = 0.0,
        seperation: Double = 20.0,
        leftPadding: Double = 10.0,
        rightPadding: Double = 10.0,
        bottomPadding: Double = 10.0
    ) {
        self.items = []
        self.seperation = seperation
        self.leftPadding = leftPadding
        self.rightPadding = rightPadding
        self.bottomPadding = bottomPadding
        self.zPosition = Constants.ZPOSITION_UI_ELEMENT

        let renderType = RenderType.sprite(spriteName: backgroundSprite)
        self.transformComponent = TransformComponent(position: position, rotation: rotation, size: size)
        self.renderComponent = RenderComponent(renderType: renderType, zPosition: zPosition)
        self.animationComponent = AnimationComponent()

        super.init()
    }

    func insert(item: ItemType, at index: Int) {
        clearViews()
        items.insert(item, at: index)
        renderViews()
    }

    func remove(at index: Int) {
        clearViews()
        items.remove(at: index)
        renderViews()
    }

    func insertTop(item: ItemType) {
        clearViews()
        items.append(item)
        renderViews()
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

    func changeItems(to newItems: [ItemType]) {
        clearViews()
        items = newItems
        renderViews()
    }

    private func clearViews() {
        for item in items {
            item.destroy()
//            EventSystem.entityChangeEvents.removeEntityEvent.post(event: RemoveEntityEvent(entity: item))
        }
    }

    private func renderViews() {
        guard let firstItem = items.first else {
            return
        }
        let startX = leftPadding - rightPadding
        let startY = -(transformComponent.size.y / 2) + (firstItem.transformComponent.size.y / 2) + bottomPadding
        var nextPosition = transformComponent.localPosition + Vector2D(startX, startY)
        for item in items {
            item.transformComponent.localPosition = nextPosition
            item.renderComponent.zPosition = zPosition + 1
            item.spawn()
            nextPosition += Vector2D(0, item.transformComponent.size.y + seperation)
        }
    }
}

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

    let transformComponent: TransformComponent
    let renderComponent: RenderComponent
    let animationComponent: AnimationComponent

    init(
        position: Vector2D,
        rotation: Double = 0.0,
        size: Vector2D,
        backgroundSprite: String,
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

        let renderType = RenderType.sprite(spriteName: backgroundSprite)

        self.transformComponent = TransformComponent(position: position, rotation: rotation, size: size)
        self.renderComponent = RenderComponent(renderType: renderType, zPosition: zPosition)
        self.animationComponent = AnimationComponent()

        super.init()

        addComponent(transformComponent)
        addComponent(renderComponent)
        addComponent(animationComponent)
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
            EventSystem.entityChangeEvents.removeEntityEvent.post(event: RemoveEntityEvent(entity: item))
        }
    }

    private func renderViews() {
        guard let firstItem = items.first else {
            return
        }
        let startX = -(transformComponent.size.x / 2) + (firstItem.transformComponent.size.x / 2) + leftPadding
        let startY = bottomPadding - topPadding
        var nextPosition = transformComponent.position + Vector2D(startX, startY)
        for item in items {
            item.transformComponent.position = nextPosition
            item.renderComponent.zPosition = zPosition + 1
            EventSystem.entityChangeEvents.addEntityEvent.post(event: AddEntityEvent(entity: item))
            nextPosition += Vector2D(item.transformComponent.size.x + seperation, 0)
        }
    }
}

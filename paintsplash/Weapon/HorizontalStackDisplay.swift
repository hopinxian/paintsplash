//
//  HorizontalStackDisplay.swift
//  paintsplash
//
//  Created by Farrell Nah on 19/3/21.
//

class HorizontalStackDisplay<ItemType: Renderable>: GameEntity, Renderable {
    var spriteName: String
    var defaultAnimation: Animation?
    var transform: Transform
    var items: [ItemType]

    let seperation: Double
    let leftPadding: Double
    let topPadding: Double
    let bottomPadding: Double

    init(
        transform: Transform,
        backgroundSprite: String,
        seperation: Double = 20.0,
        leftPadding: Double = 10.0,
        topPadding: Double = 10.0,
        bottomPadding: Double = 10.0
        ) {
        self.spriteName = backgroundSprite
        self.transform = transform
        self.defaultAnimation = nil
        self.items = []
        self.seperation = seperation
        self.leftPadding = leftPadding
        self.topPadding = topPadding
        self.bottomPadding = bottomPadding
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
            EventSystem.entityChangeEvents.removeEntityEvent.post(event: RemoveEntityEvent(entity: item))
        }
    }

    private func renderViews() {
        guard let firstItem = items.first else {
            return
        }
        var nextPosition = transform.position + Vector2D(-(transform.size.x / 2) + (firstItem.transform.size.x / 2) + leftPadding, bottomPadding - topPadding)
        for item in items {
            item.move(to: nextPosition)
            item.zPosition = zPosition + 1
            EventSystem.entityChangeEvents.addEntityEvent.post(event: AddEntityEvent(entity: item))
            nextPosition += Vector2D(item.transform.size.x + seperation, 0)
        }
    }

    override func spawn(gameManager: GameManager) {
        gameManager.getRenderSystem().addRenderable(self)
        super.spawn(gameManager: gameManager)
    }

    override func destroy(gameManager: GameManager) {
        gameManager.getRenderSystem().removeRenderable(self)
        super.destroy(gameManager: gameManager)
    }

    override func update(gameManager: GameManager) {
        gameManager.getRenderSystem().updateRenderable(self)
        super.spawn(gameManager: gameManager)
    }
}

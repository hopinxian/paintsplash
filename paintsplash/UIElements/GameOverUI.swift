//
//  GameOverUI.swift
//  paintsplash
//
//  Created by Farrell Nah on 8/4/21.
//

class GameOverUI: UIEntity, Renderable {
    var renderComponent: RenderComponent
    var transformComponent: TransformComponent
    var onQuit: () -> Void

    var titleLabel: TitleLabel
    var scoreLabel: ScoreLabel
    var backButton: BackButton

    init(score: Int, onQuit: @escaping () -> Void) {
        self.onQuit = onQuit
        self.renderComponent = RenderComponent(renderType: .sprite(spriteName: "BlackSquare"), zPosition: 1000)

        self.transformComponent = TransformComponent(position: Vector2D.zero, rotation: 0, size: Vector2D(1000, 1000))

        self.titleLabel = TitleLabel()
        self.scoreLabel = ScoreLabel(score: score)
        self.backButton = BackButton(onPress: onQuit)
    }

    override func spawn() {
        super.spawn()
        titleLabel.spawn()
        scoreLabel.spawn()
        backButton.spawn()
    }

    class TitleLabel: UIEntity, Renderable {
        var renderComponent: RenderComponent
        var transformComponent: TransformComponent

        override init() {
            self.renderComponent = RenderComponent(renderType: .label(text: "Game Over!"), zPosition: 1001)

            self.transformComponent = TransformComponent(position: Vector2D(0, 200), rotation: 0, size: Vector2D(300, 100))
        }
    }

    class ScoreLabel: UIEntity, Renderable {
        var renderComponent: RenderComponent
        var transformComponent: TransformComponent

        init(score: Int) {
            self.renderComponent = RenderComponent(renderType: .label(text: String(score)), zPosition: 1001)

            self.transformComponent = TransformComponent(position: Vector2D.zero, rotation: 0, size: Vector2D(300, 100))
        }
    }

    class BackButton: UIEntity, Renderable {
        var renderComponent: RenderComponent
        var transformComponent: TransformComponent
        var onPress: () -> Void

        init(onPress: @escaping () -> Void) {
            self.onPress = onPress
            self.renderComponent = RenderComponent(renderType: .sprite(spriteName: "YellowSquare"), zPosition: 1001)

            self.transformComponent = TransformComponent(position: Vector2D(0, -200), rotation: 0, size: Vector2D(300, 100))

            super.init()

            EventSystem.inputEvents.touchUpEvent.subscribe(listener: onTouchUp)
        }

        private func onTouchUp(event: TouchUpEvent) {
            let myBounds = Rect(from: transformComponent)
            if myBounds.contains(event.location) {
                print("Exit")
                onPress()
            }
        }
    }
}

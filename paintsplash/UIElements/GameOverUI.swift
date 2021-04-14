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

    var scoreLabel: ScoreLabel
    var backButton: BackButton

    init(score: Int, onQuit: @escaping () -> Void) {
        self.onQuit = onQuit
        self.renderComponent = RenderComponent(
            renderType: .sprite(spriteName: "GameOverWindow"),
            zPosition: 0,
            zPositionGroup: .ui
        )

        self.transformComponent = TransformComponent(position: Vector2D.zero, rotation: 0, size: Vector2D(800, 952))

        self.scoreLabel = ScoreLabel(score: score)
        self.backButton = BackButton(onPress: onQuit)
    }

    override func spawn() {
        super.spawn()
        scoreLabel.spawn()
        backButton.spawn()
    }

    class ScoreLabel: UIEntity, Renderable {
        var renderComponent: RenderComponent
        var transformComponent: TransformComponent

        init(score: Int) {
            self.renderComponent = RenderComponent(
                renderType: .label(text: "Score: \(score)", fontName: "Marker Felt", fontSize: 40, fontColor: .black),
                zPosition: 1,
                zPositionGroup: .ui
            )

            self.transformComponent = TransformComponent(position: Vector2D.zero, rotation: 0, size: Vector2D(517, 133))
        }
    }

    class BackButton: UIEntity, Renderable {
        var renderComponent: RenderComponent
        var transformComponent: TransformComponent
        var onPress: () -> Void

        init(onPress: @escaping () -> Void) {
            self.onPress = onPress

            self.renderComponent = RenderComponent(
                renderType: .sprite(spriteName: "GameOverButton"), 
                zPosition: 1, 
                zPositionGroup: .ui
            )

            self.transformComponent = TransformComponent(
                position: Vector2D(0, -200), rotation: 0, size: Vector2D(517, 133))

            super.init()

            EventSystem.inputEvents.touchUpEvent.subscribe(listener: { [weak self] in self?.onTouchUp(event: $0) })
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

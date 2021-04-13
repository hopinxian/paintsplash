//
//  LevelScore.swift
//  paintsplash
//
//  Created by Ho Pin Xian on 19/3/21.
//

class LevelScore: GameEntity, Renderable {
    var renderComponent: RenderComponent
    var transformComponent: TransformComponent

    var score = 0
    var freeze = true

    override init() {
        let renderType = RenderType.label(text: "Level Score: \(score)")

        self.renderComponent = RenderComponent(
            renderType: renderType,
            zPosition: Constants.ZPOSITION_SCORE
        )

        self.transformComponent = TransformComponent(
            position: Vector2D(-300, -495),
            rotation: 0,
            size: Vector2D(90, 50)
        )

        super.init()

        EventSystem.scoreEvent.subscribe(listener: onScoreEvent)
        self.spawn()
    }

    func onScoreEvent(event: ScoreEvent) {
        if !freeze {
            score += event.value
            let renderType = RenderType.label(text: "Level Score: \(score)")
            renderComponent.renderType = renderType
        }
    }

    func reset() {
        score = 0
    }
}

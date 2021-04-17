//
//  LevelScore.swift
//  paintsplash
//
//  Created by Ho Pin Xian on 19/3/21.
//

/**
 `LevelScore` represents the score of a level.
 */
class LevelScore: GameEntity, Renderable {
    var renderComponent: RenderComponent
    var transformComponent: TransformComponent

    var score = 0
    var freeze = true

    override init() {
        let renderType = RenderType.label(
            text: "\(score)",
            fontName: "ChalkboardSE-Bold",
            fontSize: 20,
            fontColor: .white
        )

        self.renderComponent = RenderComponent(
            renderType: renderType,
            zPosition: Constants.ZPOSITION_SCORE
        )

        self.transformComponent = TransformComponent(
            position: Constants.LEVEL_SCORE_POSITION,
            rotation: 0,
            size: Constants.LEVEL_SCORE_SIZE
        )

        super.init()

        EventSystem.scoreEvent.subscribe(listener: {
            [weak self] in self?.onScoreEvent(event: $0)
        })
        self.spawn()
    }

    /// Adds the points in the score event to the current score.
    func onScoreEvent(event: ScoreEvent) {
        if !freeze {
            score += event.value

            // Updates the score shown on the screen
            let renderType = RenderType.label(
                text: "\(score)",
                fontName: "ChalkboardSE-Bold",
                fontSize: 20,
                fontColor: .white
            )
            renderComponent.renderType = renderType
        }
    }

    func reset() {
        score = 0
    }
}

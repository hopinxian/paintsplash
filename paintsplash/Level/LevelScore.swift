//
//  LevelScore.swift
//  paintsplash
//
//  Created by Ho Pin Xian on 19/3/21.
//

class LevelScore: GameEntity, Renderable {
    var spriteName: String = "Levelscore"
    
    var defaultAnimation: Animation?
    
    var transform: Transform
    
    var score = 0
    var freeze: Bool = true
    
    override init() {
        transform = Transform(position: Vector2D.zero, rotation: 0, size: Vector2D(100, 50))
        super.init()
        EventSystem.scoreEvent.subscribe(listener: onScoreEvent)

    }
    
    func onScoreEvent(event: ScoreEvent) {
        print("Before event: " + String(score))
        if !freeze {
            score += event.value
        }
        print("After event: " + String(score))
    }
        
    func reset() {
        score = 0
    }
}

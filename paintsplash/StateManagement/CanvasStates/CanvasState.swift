//
//  CanvasState.swift
//  paintsplash
//
//  Created by Farrell Nah on 26/3/21.
//

class CanvasState: State {
    let canvas: Canvas

    init(canvas: Canvas) {
        self.canvas = canvas
    }

    class Moving: CanvasState {
        func getBehaviour(aiEntity: StatefulEntity) -> StateBehaviour {
            MoveBehaviour(direction: Vector2D(1, 0), speed: 1)
        }
    }
}

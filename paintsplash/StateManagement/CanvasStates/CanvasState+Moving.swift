//
//  CanvasState+Moving.swift
//  paintsplash
//
//  Created by Farrell Nah on 17/4/21.
//

extension CanvasState {
    class Moving: CanvasState {
        override func getStateTransition() -> State? {
            if canvas.transformComponent.worldPosition.x >= canvas.endX {
                return Die(canvas: canvas)
            } else {
                return nil
            }
        }

        func getBehaviour(aiEntity: StatefulEntity) -> StateBehaviour {
            MoveBehaviour(direction: Vector2D(1, 0), speed: Constants.CANVAS_MOVE_SPEED)
        }
    }
}

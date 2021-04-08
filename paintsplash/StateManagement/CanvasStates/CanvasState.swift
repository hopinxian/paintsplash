//
//  CanvasState.swift
//  paintsplash
//
//  Created by Farrell Nah on 26/3/21.
//

class CanvasState: State {
    unowned let canvas: Canvas

    init(canvas: Canvas) {
        self.canvas = canvas
    }

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

    class Die: CanvasState {
        override func onEnterState() {
            canvas.moveableComponent.speed = 0
            canvas.animationComponent.animate(
                animation: CanvasAnimations.canvasDisappear,
                interupt: true,
                callBack: { self.canvas.destroy() }
            )
        }

        override func getBehaviour() -> StateBehaviour {
            MoveBehaviour(direction: Vector2D(0, -1), speed: Constants.CANVAS_MOVE_SPEED)
        }
    }
}

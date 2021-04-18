//
//  CanvasState+Die.swift
//  paintsplash
//
//  Created by Farrell Nah on 17/4/21.
//

extension CanvasState {
    class Die: CanvasState {
        override func onEnterState() {
            canvas.moveableComponent.speed = 0
            canvas.animationComponent.animate(
                animation: CanvasAnimations.canvasDisappear,
                interupt: true,
                callBack: { self.canvas.destroy() }
            )

            EventSystem.audioEvent.playSoundEffectEvent.post(
                event: PlaySoundEffectEvent(effect: SoundEffect.canvasEnd)
            )
        }

        override func getBehaviour() -> StateBehaviour {
            MoveBehaviour(direction: Vector2D(0, -1), speed: Constants.CANVAS_MOVE_SPEED)
        }
    }
}

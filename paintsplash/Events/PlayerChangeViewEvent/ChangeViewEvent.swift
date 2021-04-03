//
//  ChangeViewEvent.swift
//  paintsplash
//
//  Created by Praveen Bala on 17/3/21.
//

class ChangeViewEvent: Event {
    let renderable: Renderable

    init(renderable: Renderable) {
        self.renderable = renderable
    }
}

class ChangeAnimationEvent: ChangeViewEvent {
    let animation: Animation
    let interrupt: Bool

    init(renderable: Renderable, animation: Animation, interrupt: Bool) {
        self.animation = animation
        self.interrupt = interrupt
        super.init(renderable: renderable)
    }
}

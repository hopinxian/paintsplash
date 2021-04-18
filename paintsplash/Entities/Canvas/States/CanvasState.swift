//
//  CanvasState.swift
//  paintsplash
//
//  Created by Farrell Nah on 26/3/21.
//

/// The base class for a Canvas state.
class CanvasState: State {
    unowned let canvas: Canvas

    init(canvas: Canvas) {
        self.canvas = canvas
    }
}

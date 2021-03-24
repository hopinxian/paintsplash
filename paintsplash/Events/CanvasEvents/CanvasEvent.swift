//
//  CanvasEvent.swift
//  paintsplash
//
//  Created by Cynthia Lee on 19/3/21.
//

class CanvasEvent: Event {
    var canvas: Canvas

    init(canvas: Canvas) {
        self.canvas = canvas
    }
}

//
//  ColorComponent.swift
//  paintsplash
//
//  Created by Farrell Nah on 1/4/21.
//

class ColorComponent: Component, Codable {
    var color: PaintColor

    init(color: PaintColor) {
        self.color = color
    }
}

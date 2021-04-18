//
//  TopUIBar.swift
//  paintsplash
//
//  Created by Farrell Nah on 18/4/21.
//

class TopUIBar: UIBar {
    override init(position: Vector2D = Constants.TOP_BAR_POSITION,
                  size: Vector2D = Constants.TOP_BAR_SIZE,
                  spritename: String = Constants.TOP_BAR_SPRITE) {
        super.init(position: position, size: size, spritename: spritename)
    }
}

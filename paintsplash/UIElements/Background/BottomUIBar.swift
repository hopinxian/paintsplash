//
//  BottomUIBar.swift
//  paintsplash
//
//  Created by Farrell Nah on 18/4/21.
//

class BottomUIBar: UIBar {
    override init(position: Vector2D = Constants.BOTTOM_BAR_POSITION,
                  size: Vector2D = Constants.BOTTOM_BAR_SIZE,
                  spritename: String = Constants.BOTTOM_BAR_SPRITE) {
        super.init(position: position, size: size, spritename: spritename)
    }
}

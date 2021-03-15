//
//  GameColor.swift
//  paintsplash
//
//  Created by Ho Pin Xian on 14/3/21.
//

/**
 `GameColor` represents a color that can mix with other colors
 and contain other colors.
 */
protocol GameColor {
    /// Returns the resulting color from mixing this color with the given colors.
    /// Returns nothing if there is no existing color result.
    func mix(with color: [Self]) -> Self?

    /// Checks if this color contains the given color.
    func contains(color: Self) -> Bool

    /// Returns an array of colors which this color contains.
    func getSubColors() -> [Self]
}

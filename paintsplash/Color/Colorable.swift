//
//  Colorable.swift
//  paintsplash
//
//  Created by Praveen Bala on 8/3/21.
//

/**
 `Colorable` is a type that has a color.
 */
protocol Colorable {
    associatedtype ColorType: GameColor
    var color: ColorType { get set }
}

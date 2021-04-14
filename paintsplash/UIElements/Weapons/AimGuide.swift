//
//  AimGuide.swift
//  paintsplash
//
//  Created by Farrell Nah on 10/4/21.
//

protocol AimGuide: Renderable {
    var direction: Vector2D { get set }
    func aim(at direction: Vector2D)
}

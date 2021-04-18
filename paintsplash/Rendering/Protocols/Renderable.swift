//
//  Renderable.swift
//  paintsplash
//
//  Created by Farrell Nah on 10/3/21.
//
import SpriteKit

protocol Renderable: Transformable {
    var renderComponent: RenderComponent { get set }
}

//
//  RenderableSystem.swift
//  paintsplash
//
//  Created by Praveen Bala on 8/3/21.
//
protocol RenderSystem {
    func add(_ renderable: Renderable)
    func remove(_ renderable: Renderable)
    func updateRenderable(renderable: Renderable)
}

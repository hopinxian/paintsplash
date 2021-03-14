//
//  RenderableSystem.swift
//  paintsplash
//
//  Created by Praveen Bala on 8/3/21.
//
protocol RenderSystem {
    func addRenderable(_ renderable: Renderable)
    func removeRenderable(_ renderable: Renderable)
    func updateRenderable(renderable: Renderable)
}

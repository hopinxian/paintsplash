//
//  NetworkSource.swift
//  paintsplash
//
//  Created by Farrell Nah on 1/4/21.
//

protocol NetworkSource: Renderable, Animatable, Colorable {
    var networkComponent: NetworkComponent { get }
}

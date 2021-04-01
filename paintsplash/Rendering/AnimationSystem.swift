//
//  AnimationSystem.swift
//  paintsplash
//
//  Created by Farrell Nah on 26/3/21.
//

protocol AnimationSystem: System {
    var animatables: [EntityID: Animatable] { get set }
}

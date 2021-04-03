//
//  AnimationSource.swift
//  paintsplash
//
//  Created by Farrell Nah on 3/4/21.
//

protocol AnimationSource {
    var animations: [String: Animation] { get }
    func getAnimation(from identifier: String) -> Animation?
}

extension AnimationSource {
    func getAnimation(from identifier: String) -> Animation? {
        animations[identifier]
    }
}
